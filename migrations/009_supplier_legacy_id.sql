-- 009_supplier_legacy_id.sql
-- Adds a legacy_id BIGINT column to suppliers for backward compatibility
-- with existing numeric IDs used by receipts and other modules.

ALTER TABLE public.suppliers ADD COLUMN IF NOT EXISTS legacy_id BIGINT;

CREATE INDEX IF NOT EXISTS idx_suppliers_legacy_id ON public.suppliers(legacy_id);
