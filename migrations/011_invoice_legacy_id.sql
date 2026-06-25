-- 011_invoice_legacy_id.sql
-- Adds backward-compatible columns to invoices:
--   legacy_id         BIGINT  — numeric sequence ID for backward compat
--   legacy_client_id  BIGINT  — numeric client reference for backward compat

ALTER TABLE public.invoices ADD COLUMN IF NOT EXISTS legacy_id BIGINT;
ALTER TABLE public.invoices ADD COLUMN IF NOT EXISTS legacy_client_id BIGINT;

CREATE INDEX IF NOT EXISTS idx_invoices_legacy_id ON public.invoices(legacy_id);
