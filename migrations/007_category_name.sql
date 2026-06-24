-- 007_category_name.sql
-- Adds a category_name TEXT column to products for backward compatibility
-- with the existing string-based category field.

ALTER TABLE public.products ADD COLUMN IF NOT EXISTS category_name TEXT DEFAULT '';
