-- 010_reception_legacy_id.sql
-- Adds backward-compatible columns to receipts:
--   legacy_id          BIGINT  — numeric sequence ID for backward compat
--   legacy_supplier_id BIGINT  — numeric supplier reference for backward compat

ALTER TABLE public.receipts ADD COLUMN IF NOT EXISTS legacy_id BIGINT;
ALTER TABLE public.receipts ADD COLUMN IF NOT EXISTS legacy_supplier_id BIGINT;

CREATE INDEX IF NOT EXISTS idx_receipts_legacy_id ON public.receipts(legacy_id);
