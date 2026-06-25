-- 012_stock_history.sql
-- Migration: Adds legacy fields to stock_movements for backward compatibility

ALTER TABLE public.stock_movements ADD COLUMN IF NOT EXISTS legacy_id BIGINT;
ALTER TABLE public.stock_movements ADD COLUMN IF NOT EXISTS legacy_product_id BIGINT;

CREATE INDEX IF NOT EXISTS idx_stock_movements_legacy_id       ON public.stock_movements(legacy_id);
CREATE INDEX IF NOT EXISTS idx_stock_movements_legacy_product  ON public.stock_movements(legacy_product_id);
