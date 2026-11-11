// G1 Input Validator — Capstone 1: Order Intelligence Bot
// Checks every chat message BEFORE it reaches the AI.
const item = $input.first().json;
const raw = String(item.chatInput || '').trim();
const sessionId = item.sessionId;
let blocked = false;
let reason = '';

// 1) Length check
if (raw.length === 0) { blocked = true; reason = 'empty'; }
else if (raw.length > 500) { blocked = true; reason = 'too_long'; }

// 2) SQL write / admin commands (the bot is read-only)
const sqlWrite = [
  /\b(drop|truncate|alter|grant|revoke)\b/i,
  /\bdelete\s+from\b/i,
  /\binsert\s+into\b/i,
  /\bupdate\s+\w+\s+set\b/i,
  /;\s*\w+/            // stacked statements like "x; DROP ..."
];
if (!blocked && sqlWrite.some(r => r.test(raw))) { blocked = true; reason = 'sql_write_attempt'; }

// 3) Prompt injection
const injection = [
  /ignore (all |any |the )?(previous|above|prior|your) (instructions|rules)/i,
  /(reveal|show|print).{0,20}(system prompt|instructions|password|credentials)/i,
  /you are now|act as|pretend to be|jailbreak|developer mode/i
];
if (!blocked && injection.some(r => r.test(raw))) { blocked = true; reason = 'prompt_injection'; }

// 4) PII masking (emails, Indian phone numbers)
const masked = raw
  .replace(/[\w.+-]+@[\w-]+\.[\w.]+/g, '[EMAIL]')
  .replace(/(\+91[-\s]?)?[6-9]\d{4}[-\s]?\d{5}\b/g, '[PHONE]');

// 5) Off-topic check: must mention something about the order data
const topicWords = /\b(order|orders|revenue|sales|sale|sold|customer|customers|delivery|deliveries|delivered|courier|couriers|bluedart|delhivery|ecom|india post|product|products|category|categories|city|cities|state|segment|premium|regular|payment|upi|cod|card|cash|amount|total|average|avg|count|how many|top|best|worst|month|week|september|october|shipped|returned|cancelled|delayed|late|pending|status|quantity|aov|electronics|footwear|apparel|furniture|fitness|kitchen|accessories)\b/i;
if (!blocked && !topicWords.test(masked)) { blocked = true; reason = 'off_topic'; }

const replies = {
  empty: 'Please type a question about orders, customers or deliveries.',
  too_long: 'That message is too long. Please keep questions under 500 characters.',
  sql_write_attempt: 'I can only READ order data. Changing or deleting data is not allowed.',
  prompt_injection: 'I can\'t do that. I only answer questions about the order data.',
  off_topic: 'I only answer questions about orders, customers, revenue and deliveries. Try: "What is our total net revenue?"'
};

return [{ json: {
  chatInput: masked,
  sessionId,
  blocked,
  reason: blocked ? reason : 'ok',
  output: blocked ? replies[reason] : ''
}}];
