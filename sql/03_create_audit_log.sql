-- 03_create_audit_log.sql
-- Capstone #4: audit log. One row per chat message (answered AND blocked).
-- Written by n8n with the admin (service_role) credential.
-- ai_reader gets NO access, so the AI can never read or change its own log.

CREATE TABLE IF NOT EXISTS bot_audit_log (
  id            BIGSERIAL PRIMARY KEY,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  session_id    TEXT,
  question      TEXT,          -- after G1 masking ([EMAIL] / [PHONE])
  blocked       BOOLEAN NOT NULL DEFAULT false,
  block_reason  TEXT,          -- ok / sql_write_attempt / prompt_injection / off_topic / ...
  sql_used      TEXT,          -- the exact SQL the AI ran (from the tool call)
  tool_calls    INTEGER,       -- how many SQL queries the AI ran
  answer        TEXT,
  status        TEXT CHECK (status IN ('answered','blocked','no_sql'))
                               -- no_sql = AI answered WITHOUT running SQL (red flag)
);

ALTER TABLE bot_audit_log ENABLE ROW LEVEL SECURITY;

-- Checkpoint: expect  bot_audit_log | 0 | false
SELECT
  'bot_audit_log'                                         AS table_name,
  (SELECT COUNT(*) FROM bot_audit_log)                    AS rows_now,
  has_table_privilege('ai_reader', 'bot_audit_log', 'SELECT') AS ai_reader_can_read;
