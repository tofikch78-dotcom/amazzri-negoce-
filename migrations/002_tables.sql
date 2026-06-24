-- 002_tables.sql
-- Run second: creates all tables in dependency order.

-- ── PROFILES (extends auth.users) ──
CREATE TABLE IF NOT EXISTS public.profiles (
  id            UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  username      TEXT UNIQUE NOT NULL,
  display_name  TEXT,
  role          TEXT NOT NULL DEFAULT 'admin' CHECK (role IN ('admin', 'manager')),
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ── COMPANY ──
CREATE TABLE IF NOT EXISTS public.company (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name        TEXT NOT NULL DEFAULT 'AMAZZRI NEGOCE',
  type        TEXT DEFAULT 'SARL',
  tag         TEXT DEFAULT 'IMPORT & EXPORT',
  activity    TEXT,
  address     TEXT,
  phone       TEXT,
  email       TEXT,
  website     TEXT,
  rc          TEXT,
  if_code     TEXT,
  pte         TEXT,
  cnss        TEXT,
  ice         TEXT,
  logo_url    TEXT,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ── CATEGORIES (normalized out of Product.category string) ──
CREATE TABLE IF NOT EXISTS public.categories (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name        TEXT NOT NULL,
  emoji       TEXT DEFAULT '📦',
  company_id  UUID REFERENCES public.company(id) ON DELETE CASCADE,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(name, company_id)
);

-- ── PRODUCTS ──
CREATE TABLE IF NOT EXISTS public.products (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name        TEXT NOT NULL,
  category_id UUID REFERENCES public.categories(id) ON DELETE SET NULL,
  unit        TEXT NOT NULL DEFAULT 'Pcs',
  emoji       TEXT DEFAULT '📦',
  buy_price   NUMERIC(12,2) NOT NULL DEFAULT 0,
  sell_price  NUMERIC(12,2) NOT NULL DEFAULT 0,
  stock_qty   NUMERIC(12,2) NOT NULL DEFAULT 0,
  threshold   NUMERIC(12,2) NOT NULL DEFAULT 5,
  company_id  UUID REFERENCES public.company(id) ON DELETE CASCADE,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ── CLIENTS ──
CREATE TABLE IF NOT EXISTS public.clients (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nom         TEXT NOT NULL,
  ice         TEXT DEFAULT '',
  if_code     TEXT DEFAULT '',
  rc          TEXT DEFAULT '',
  telephone   TEXT DEFAULT '',
  email       TEXT DEFAULT '',
  adresse     TEXT DEFAULT '',
  ville       TEXT DEFAULT '',
  company_id  UUID REFERENCES public.company(id) ON DELETE CASCADE,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ── SUPPLIERS ──
CREATE TABLE IF NOT EXISTS public.suppliers (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nom         TEXT NOT NULL,
  ice         TEXT DEFAULT '',
  telephone   TEXT DEFAULT '',
  email       TEXT DEFAULT '',
  adresse     TEXT DEFAULT '',
  ville       TEXT DEFAULT '',
  company_id  UUID REFERENCES public.company(id) ON DELETE CASCADE,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ── INVOICES ──
CREATE TABLE IF NOT EXISTS public.invoices (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  seq_id        INTEGER NOT NULL,
  display_id    TEXT NOT NULL,
  client_id     UUID REFERENCES public.clients(id) ON DELETE SET NULL,
  client_name   TEXT NOT NULL DEFAULT '—',
  client_ice    TEXT DEFAULT '',
  client_tel    TEXT DEFAULT '',
  client_addr   TEXT DEFAULT '',
  note          TEXT DEFAULT '',
  issue_date    DATE NOT NULL,
  lines         JSONB NOT NULL DEFAULT '[]',
  total         NUMERIC(12,2) NOT NULL,
  tva           NUMERIC(12,2),
  mode          TEXT DEFAULT 'espece' CHECK (mode IN ('espece', 'cheque', 'virement')),
  mode_ref      TEXT DEFAULT '',
  created_by    UUID REFERENCES auth.users(id),
  company_id    UUID REFERENCES public.company(id) ON DELETE CASCADE,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ── RECEIPTS (stock receptions) ──
CREATE TABLE IF NOT EXISTS public.receipts (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  seq_id        INTEGER NOT NULL,
  display_id    TEXT NOT NULL,
  supplier_id   UUID REFERENCES public.suppliers(id) ON DELETE SET NULL,
  supplier_name TEXT NOT NULL DEFAULT '—',
  receipt_date  DATE NOT NULL,
  lines         JSONB NOT NULL DEFAULT '[]',
  total_items   NUMERIC(12,2) NOT NULL,
  notes         TEXT DEFAULT '',
  created_by    UUID REFERENCES auth.users(id),
  company_id    UUID REFERENCES public.company(id) ON DELETE CASCADE,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ── STOCK MOVEMENTS ──
CREATE TABLE IF NOT EXISTS public.stock_movements (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id      UUID NOT NULL REFERENCES public.products(id) ON DELETE CASCADE,
  product_name    TEXT NOT NULL,
  movement_date   DATE NOT NULL,
  type            movement_type NOT NULL,
  quantity        NUMERIC(12,2) NOT NULL,
  stock_before    NUMERIC(12,2) NOT NULL,
  stock_after     NUMERIC(12,2) NOT NULL,
  note            TEXT DEFAULT '',
  reference_id    UUID,
  reference_type  TEXT CHECK (reference_type IN ('invoice', 'receipt', 'adjustment')),
  created_by      UUID REFERENCES auth.users(id),
  company_id      UUID REFERENCES public.company(id) ON DELETE CASCADE,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);
