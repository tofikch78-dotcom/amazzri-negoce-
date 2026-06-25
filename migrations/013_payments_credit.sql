-- 013_payments_credit.sql
-- Adds payment tracking, invoice status management, and client credit limits.
-- Run after all previous migrations have been applied.

-- ── PAYMENTS TABLE ──
CREATE TABLE IF NOT EXISTS public.payments (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  legacy_id         BIGINT NOT NULL,
  client_id         UUID REFERENCES public.clients(id) ON DELETE SET NULL,
  client_legacy_id  BIGINT,
  invoice_display_id TEXT,
  payment_date      DATE NOT NULL,
  amount            NUMERIC(12,2) NOT NULL CHECK (amount > 0),
  mode              TEXT NOT NULL DEFAULT 'espece'
                      CHECK (mode IN ('espece', 'cheque', 'virement', 'versement')),
  mode_ref          TEXT DEFAULT '',
  note              TEXT DEFAULT '',
  company_id        UUID REFERENCES public.company(id) ON DELETE CASCADE,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  created_by        UUID REFERENCES auth.users(id) ON DELETE SET NULL
);

-- ── INVOICE-PAYMENTS JUNCTION ──
CREATE TABLE IF NOT EXISTS public.invoice_payments (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  invoice_id  UUID NOT NULL REFERENCES public.invoices(id) ON DELETE CASCADE,
  payment_id  UUID NOT NULL REFERENCES public.payments(id) ON DELETE CASCADE,
  amount      NUMERIC(12,2) NOT NULL CHECK (amount > 0),
  UNIQUE(invoice_id, payment_id)
);

-- ── ADD COLUMNS TO INVOICES ──
ALTER TABLE public.invoices ADD COLUMN IF NOT EXISTS due_date DATE;
ALTER TABLE public.invoices ADD COLUMN IF NOT EXISTS status TEXT NOT NULL DEFAULT 'pending'
  CHECK (status IN ('pending', 'partial', 'paid', 'overdue', 'cancelled'));
ALTER TABLE public.invoices ADD COLUMN IF NOT EXISTS total_paid NUMERIC(12,2) NOT NULL DEFAULT 0;
ALTER TABLE public.invoices ADD COLUMN IF NOT EXISTS paid_at TIMESTAMPTZ;

-- ── ADD COLUMNS TO CLIENTS ──
ALTER TABLE public.clients ADD COLUMN IF NOT EXISTS credit_limit NUMERIC(12,2) NOT NULL DEFAULT 0;
ALTER TABLE public.clients ADD COLUMN IF NOT EXISTS balance NUMERIC(12,2) NOT NULL DEFAULT 0;

-- ── INDEXES ──
CREATE INDEX IF NOT EXISTS idx_payments_client      ON public.payments(client_legacy_id);
CREATE INDEX IF NOT EXISTS idx_payments_date        ON public.payments(payment_date);
CREATE INDEX IF NOT EXISTS idx_payments_legacy_id   ON public.payments(legacy_id);
CREATE INDEX IF NOT EXISTS idx_invoice_payments_invoice ON public.invoice_payments(invoice_id);
CREATE INDEX IF NOT EXISTS idx_invoice_payments_payment ON public.invoice_payments(payment_id);
CREATE INDEX IF NOT EXISTS idx_invoices_status      ON public.invoices(status);
CREATE INDEX IF NOT EXISTS idx_invoices_due_date    ON public.invoices(due_date);

-- ── ENABLE RLS ──
ALTER TABLE public.payments         ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.invoice_payments ENABLE ROW LEVEL SECURITY;

-- ── RLS POLICIES FOR PAYMENTS ──
CREATE POLICY "authenticated select payments"
  ON public.payments FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE POLICY "authenticated insert payments"
  ON public.payments FOR INSERT
  WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "authenticated update payments"
  ON public.payments FOR UPDATE
  USING (auth.role() = 'authenticated')
  WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "authenticated delete payments"
  ON public.payments FOR DELETE
  USING (auth.role() = 'authenticated');

-- ── RLS POLICIES FOR INVOICE_PAYMENTS ──
CREATE POLICY "authenticated select invoice_payments"
  ON public.invoice_payments FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE POLICY "authenticated insert invoice_payments"
  ON public.invoice_payments FOR INSERT
  WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "authenticated update invoice_payments"
  ON public.invoice_payments FOR UPDATE
  USING (auth.role() = 'authenticated')
  WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "authenticated delete invoice_payments"
  ON public.invoice_payments FOR DELETE
  USING (auth.role() = 'authenticated');
