-- 006_legacy_id.sql
-- Adds a legacy_id BIGINT column to products for backward compatibility
-- with existing numeric IDs used by invoices, receipts, and stock_movements.

ALTER TABLE public.products ADD COLUMN IF NOT EXISTS legacy_id BIGINT;

CREATE INDEX IF NOT EXISTS idx_products_legacy_id ON public.products(legacy_id);

-- Make legacy_id unique per company for consistency
-- (not enforced as UNIQUE during migration to avoid conflicts with nulls)
