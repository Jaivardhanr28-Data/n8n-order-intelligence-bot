// Build audit row — Capstone 1: Order Intelligence Bot
// Runs after EITHER "Blocked reply" OR "AI Agent (SQL analyst)".
// Collects one log row: question, blocked?, the exact SQL the AI ran, answer.
const g1  = $('G1_input_validator').first().json;   // masked question + block info
const cur = $input.first().json;                     // reply from whichever path ran
const steps = Array.isArray(cur.intermediateSteps) ? cur.intermediateSteps : [];

// 1) SQL taken from the real tool calls (what actually ran on the database)
const sqls = steps
  .filter(s => s && s.action)
  .map(s => {
    const ti = s.action.toolInput;
    if (typeof ti === 'string') return ti;
    if (ti && ti.sql_query) return ti.sql_query;
    if (ti && ti.query) return ti.query;
    return ti ? JSON.stringify(ti) : '';
  })
  .filter(Boolean);

// 2) Status
let status;
if (g1.blocked) status = 'blocked';
else if (sqls.length > 0) status = 'answered';
else status = 'no_sql';   // AI answered WITHOUT running SQL -> red flag

return [{ json: {
  session_id:   g1.sessionId || null,
  question:     g1.chatInput,
  blocked:      g1.blocked === true,
  block_reason: g1.reason,
  sql_used:     sqls.length ? sqls.join('\n---\n') : null,
  tool_calls:   sqls.length,
  answer:       cur.output || '',
  status
}}];
