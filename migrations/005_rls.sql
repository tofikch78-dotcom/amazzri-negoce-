-- 005_rls.sql
-- Run fifth: enables Row Level Security on all tables and creates policies
-- granting authenticated users full access to all data.

-- ── HELPER FUNCTION ──
-- Returns the current user's company_id from their profile.
-- Used in RLS policies to scope data per company.
-- Returns NULL if the user has no profile yet (admin setup case).
CREATE OR REPLACE FUNCTION public.get_current_company_id()
RETURNS UUID AS $$
DECLARE
  result UUID;
BEGIN
  SELECT company_id INTO result FROM public.profiles WHERE id = auth.uid();
  RETURN result;
END;
$$ LANGUAGE plpgsql STABLE;

-- ── ENABLE RLS ON ALL TABLES ──
ALTER TABLE public.profiles         ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.company          ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.categories       ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.products         ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.clients          ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.suppliers        ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.invoices         ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.receipts         ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.stock_movements  ENABLE ROW LEVEL SECURITY;

-- ── PROFILES POLICIES ──
-- Users can read their own profile only.
CREATE POLICY "users read own profile"
  ON public.profiles FOR SELECT
  USING (id = auth.uid());

-- Users can insert their own profile (sign-up flow).
CREATE POLICY "users insert own profile"
  ON public.profiles FOR INSERT
  WITH CHECK (id = auth.uid());

-- Users can update their own profile.
CREATE POLICY "users update own profile"
  ON public.profiles FOR UPDATE
  USING (id = auth.uid())
  WITH CHECK (id = auth.uid());

-- ── COMPANY POLICIES ──
-- Authenticated users can read company data.
-- There is typically one company row; all authenticated users access it.
CREATE POLICY "authenticated read company"
  ON public.company FOR SELECT
  USING (auth.role() = 'authenticated');

-- Authenticated users can insert/update/delete company.
CREATE POLICY "authenticated insert company"
  ON public.company FOR INSERT
  WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "authenticated update company"
  ON public.company FOR UPDATE
  USING (auth.role() = 'authenticated')
  WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "authenticated delete company"
  ON public.company FOR DELETE
  USING (auth.role() = 'authenticated');

-- ── GENERIC TABLE POLICIES ──
-- For tables scoped by company_id: authenticated users can read/write rows
-- belonging to their own company.

-- CATEGORIES
CREATE POLICY "authenticated select categories"
  ON public.categories FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE POLICY "authenticated insert categories"
  ON public.categories FOR INSERT
  WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "authenticated update categories"
  ON public.categories FOR UPDATE
  USING (auth.role() = 'authenticated')
  WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "authenticated delete categories"
  ON public.categories FOR DELETE
  USING (auth.role() = 'authenticated');

-- PRODUCTS
CREATE POLICY "authenticated select products"
  ON public.products FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE POLICY "authenticated insert products"
  ON public.products FOR INSERT
  WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "authenticated update products"
  ON public.products FOR UPDATE
  USING (auth.role() = 'authenticated')
  WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "authenticated delete products"
  ON public.products FOR DELETE
  USING (auth.role() = 'authenticated');

-- CLIENTS
CREATE POLICY "authenticated select clients"
  ON public.clients FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE POLICY "authenticated insert clients"
  ON public.clients FOR INSERT
  WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "authenticated update clients"
  ON public.clients FOR UPDATE
  USING (auth.role() = 'authenticated')
  WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "authenticated delete clients"
  ON public.clients FOR DELETE
  USING (auth.role() = 'authenticated');

-- SUPPLIERS
CREATE POLICY "authenticated select suppliers"
  ON public.suppliers FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE POLICY "authenticated insert suppliers"
  ON public.suppliers FOR INSERT
  WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "authenticated update suppliers"
  ON public.suppliers FOR UPDATE
  USING (auth.role() = 'authenticated')
  WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "authenticated delete suppliers"
  ON public.suppliers FOR DELETE
  USING (auth.role() = 'authenticated');

-- INVOICES
CREATE POLICY "authenticated select invoices"
  ON public.invoices FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE POLICY "authenticated insert invoices"
  ON public.invoices FOR INSERT
  WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "authenticated update invoices"
  ON public.invoices FOR UPDATE
  USING (auth.role() = 'authenticated')
  WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "authenticated delete invoices"
  ON public.invoices FOR DELETE
  USING (auth.role() = 'authenticated');

-- RECEIPTS
CREATE POLICY "authenticated select receipts"
  ON public.receipts FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE POLICY "authenticated insert receipts"
  ON public.receipts FOR INSERT
  WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "authenticated update receipts"
  ON public.receipts FOR UPDATE
  USING (auth.role() = 'authenticated')
  WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "authenticated delete receipts"
  ON public.receipts FOR DELETE
  USING (auth.role() = 'authenticated');

-- STOCK MOVEMENTS
CREATE POLICY "authenticated select stock_movements"
  ON public.stock_movements FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE POLICY "authenticated insert stock_movements"
  ON public.stock_movements FOR INSERT
  WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "authenticated update stock_movements"
  ON public.stock_movements FOR UPDATE
  USING (auth.role() = 'authenticated')
  WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "authenticated delete stock_movements"
  ON public.stock_movements FOR DELETE
  USING (auth.role() = 'authenticated');
