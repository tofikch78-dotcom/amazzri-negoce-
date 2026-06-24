-- 003_indexes.sql
-- Run third: creates all indexes for query performance.

-- PRODUCTS
CREATE INDEX IF NOT EXISTS idx_products_company   ON public.products(company_id);
CREATE INDEX IF NOT EXISTS idx_products_category  ON public.products(category_id);
CREATE INDEX IF NOT EXISTS idx_products_name      ON public.products USING gin (name gin_trgm_ops);

-- INVOICES
CREATE INDEX IF NOT EXISTS idx_invoices_company   ON public.invoices(company_id);
CREATE INDEX IF NOT EXISTS idx_invoices_date      ON public.invoices(issue_date);
CREATE INDEX IF NOT EXISTS idx_invoices_seq       ON public.invoices(company_id, seq_id);
CREATE INDEX IF NOT EXISTS idx_invoices_client    ON public.invoices(client_id);
CREATE INDEX IF NOT EXISTS idx_invoices_lines     ON public.invoices USING GIN (lines);
CREATE INDEX IF NOT EXISTS idx_invoices_created_by ON public.invoices(created_by);

-- RECEIPTS
CREATE INDEX IF NOT EXISTS idx_receipts_company   ON public.receipts(company_id);
CREATE INDEX IF NOT EXISTS idx_receipts_date      ON public.receipts(receipt_date);
CREATE INDEX IF NOT EXISTS idx_receipts_supplier  ON public.receipts(supplier_id);
CREATE INDEX IF NOT EXISTS idx_receipts_created_by ON public.receipts(created_by);

-- CLIENTS
CREATE INDEX IF NOT EXISTS idx_clients_company    ON public.clients(company_id);
CREATE INDEX IF NOT EXISTS idx_clients_nom        ON public.clients USING gin (nom gin_trgm_ops);

-- SUPPLIERS
CREATE INDEX IF NOT EXISTS idx_suppliers_company  ON public.suppliers(company_id);
CREATE INDEX IF NOT EXISTS idx_suppliers_nom      ON public.suppliers USING gin (nom gin_trgm_ops);

-- STOCK MOVEMENTS
CREATE INDEX IF NOT EXISTS idx_movements_product  ON public.stock_movements(product_id);
CREATE INDEX IF NOT EXISTS idx_movements_date     ON public.stock_movements(movement_date);
CREATE INDEX IF NOT EXISTS idx_movements_company  ON public.stock_movements(company_id);
CREATE INDEX IF NOT EXISTS idx_movements_reference ON public.stock_movements(reference_id);

-- CATEGORIES
CREATE INDEX IF NOT EXISTS idx_categories_company ON public.categories(company_id);

-- COMPANY
CREATE UNIQUE INDEX IF NOT EXISTS idx_company_single ON public.company((true));
