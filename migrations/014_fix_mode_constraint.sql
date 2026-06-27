-- 014_fix_mode_constraint.sql
-- Fixes: migration 013 added the 'credit' invoice mode but did not update
-- the invoices.mode CHECK constraint, causing 400 on inserts with mode='credit'.
ALTER TABLE public.invoices DROP CONSTRAINT IF EXISTS invoices_mode_check;
ALTER TABLE public.invoices ADD CONSTRAINT invoices_mode_check
  CHECK (mode IN ('espece', 'cheque', 'virement', 'credit'));
