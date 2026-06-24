-- 001_extensions_enums.sql
-- Run first: enables required extensions and creates custom types.

-- Enable UUID generation (already enabled in Supabase by default, but idempotent)
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Custom enum for stock movement types
DO $$ BEGIN
  CREATE TYPE movement_type AS ENUM ('STOCK_IN', 'STOCK_OUT', 'SALE', 'ADJUSTMENT');
EXCEPTION
  WHEN duplicate_object THEN NULL;
END $$;
