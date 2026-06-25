-- 008_client_legacy_id.sql
-- Adds a legacy_id BIGINT column to clients for backward compatibility
-- with existing numeric IDs used by invoices and other modules.

ALTER TABLE public.clients ADD COLUMN IF NOT EXISTS legacy_id BIGINT;

CREATE INDEX IF NOT EXISTS idx_clients_legacy_id ON public.clients(legacy_id);
