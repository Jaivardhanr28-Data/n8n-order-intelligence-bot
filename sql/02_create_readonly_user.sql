-- 02_create_readonly_user.sql
-- Capstone #4: a read-only login for the AI (scope guardrail).
-- BEFORE RUNNING: replace CHANGE_ME_STRONG_PASSWORD (line 9) with your own password.
-- Store it in a password manager. Never commit it to GitHub.

-- 1) Create the login (re-runnable)
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'ai_reader') THEN
    CREATE ROLE ai_reader WITH LOGIN PASSWORD 'CHANGE_ME_STRONG_PASSWORD';
  END IF;
END $$;

-- 2) Read-only safety settings
ALTER ROLE ai_reader SET default_transaction_read_only = on;  -- any write is refused
ALTER ROLE ai_reader SET statement_timeout = '10s';           -- no runaway queries

-- 3) Access to ONLY the 3 order tables (not documents / audit_logs)
GRANT USAGE ON SCHEMA public TO ai_reader;
GRANT SELECT ON customers, orders, deliveries TO ai_reader;

-- 4) RLS is ON, so the role also needs a "can read" policy on each table
DROP POLICY IF EXISTS ai_reader_select ON customers;
DROP POLICY IF EXISTS ai_reader_select ON orders;
DROP POLICY IF EXISTS ai_reader_select ON deliveries;
CREATE POLICY ai_reader_select ON customers  FOR SELECT TO ai_reader USING (true);
CREATE POLICY ai_reader_select ON orders     FOR SELECT TO ai_reader USING (true);
CREATE POLICY ai_reader_select ON deliveries FOR SELECT TO ai_reader USING (true);

-- Checkpoint: expect  t | t | t | f | f
SELECT
  has_table_privilege('ai_reader', 'orders',     'SELECT') AS can_read_orders,
  has_table_privilege('ai_reader', 'customers',  'SELECT') AS can_read_customers,
  has_table_privilege('ai_reader', 'deliveries', 'SELECT') AS can_read_deliveries,
  has_table_privilege('ai_reader', 'orders',     'DELETE') AS can_delete_orders,
  has_table_privilege('ai_reader', 'documents',  'SELECT') AS can_read_documents;
