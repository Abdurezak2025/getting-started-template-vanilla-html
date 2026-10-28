-- ================================================================
-- Sena FarmERP Enterprise Supabase schema
-- Version: 1.0
-- Purpose: Agribusiness ERP with local-first + cloud sync ready
-- ================================================================

CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Core organization model
CREATE TABLE IF NOT EXISTS organizations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  legal_name TEXT,
  country TEXT,
  region TEXT,
  timezone TEXT DEFAULT 'Africa/Addis_Ababa',
  status TEXT DEFAULT 'active',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS profiles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  auth_user_id UUID,
  org_id UUID REFERENCES organizations(id) ON DELETE CASCADE,
  full_name TEXT NOT NULL,
  email TEXT UNIQUE,
  phone TEXT,
  role TEXT NOT NULL,
  department TEXT,
  status TEXT DEFAULT 'active',
  avatar_url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS app_settings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id UUID REFERENCES organizations(id) ON DELETE CASCADE,
  key TEXT NOT NULL,
  value JSONB NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(org_id, key)
);

-- Farm and field assets
CREATE TABLE IF NOT EXISTS farms (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id UUID REFERENCES organizations(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  code TEXT UNIQUE,
  location_name TEXT,
  region TEXT,
  country TEXT,
  latitude DOUBLE PRECISION,
  longitude DOUBLE PRECISION,
  acreage NUMERIC(10,2),
  crop_type TEXT,
  soil_type TEXT,
  status TEXT DEFAULT 'active',
  created_by UUID REFERENCES profiles(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS plots (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  farm_id UUID REFERENCES farms(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  area_ha NUMERIC(10,2),
  geometry JSONB,
  crop_type TEXT,
  planting_date DATE,
  expected_harvest_date DATE,
  status TEXT DEFAULT 'healthy',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Operations and field activity
CREATE TABLE IF NOT EXISTS operations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id UUID REFERENCES organizations(id) ON DELETE CASCADE,
  farm_id UUID REFERENCES farms(id) ON DELETE SET NULL,
  plot_id UUID REFERENCES plots(id) ON DELETE SET NULL,
  title TEXT NOT NULL,
  operation_type TEXT,
  priority TEXT DEFAULT 'medium',
  owner_id UUID REFERENCES profiles(id),
  status TEXT DEFAULT 'planned',
  scheduled_for TIMESTAMPTZ,
  started_at TIMESTAMPTZ,
  completed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS field_observations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id UUID REFERENCES organizations(id) ON DELETE CASCADE,
  plot_id UUID REFERENCES plots(id) ON DELETE CASCADE,
  observed_by UUID REFERENCES profiles(id),
  observation_type TEXT,
  health_score NUMERIC(5,2),
  moisture_pct NUMERIC(5,2),
  notes TEXT,
  latitude DOUBLE PRECISION,
  longitude DOUBLE PRECISION,
  media_url TEXT,
  captured_at TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS sensor_data (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id UUID REFERENCES organizations(id) ON DELETE CASCADE,
  plot_id UUID REFERENCES plots(id) ON DELETE CASCADE,
  sensor_type TEXT,
  metric_name TEXT,
  metric_value NUMERIC,
  unit TEXT,
  reading_at TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Procurement and finance
CREATE TABLE IF NOT EXISTS suppliers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id UUID REFERENCES organizations(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  category TEXT,
  contact_name TEXT,
  phone TEXT,
  email TEXT,
  status TEXT DEFAULT 'active',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS purchase_orders (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id UUID REFERENCES organizations(id) ON DELETE CASCADE,
  supplier_id UUID REFERENCES suppliers(id) ON DELETE SET NULL,
  code TEXT UNIQUE,
  total_amount NUMERIC(14,2),
  currency TEXT DEFAULT 'USD',
  status TEXT DEFAULT 'draft',
  requested_by UUID REFERENCES profiles(id),
  approved_by UUID REFERENCES profiles(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS invoices (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id UUID REFERENCES organizations(id) ON DELETE CASCADE,
  vendor_name TEXT,
  invoice_number TEXT,
  total_amount NUMERIC(14,2),
  currency TEXT DEFAULT 'USD',
  due_date DATE,
  status TEXT DEFAULT 'pending',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS financial_transactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id UUID REFERENCES organizations(id) ON DELETE CASCADE,
  account_name TEXT NOT NULL,
  transaction_type TEXT NOT NULL,
  amount NUMERIC(14,2) NOT NULL,
  currency TEXT DEFAULT 'USD',
  status TEXT DEFAULT 'pending',
  reference TEXT,
  occurred_at TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- AI and analytics
CREATE TABLE IF NOT EXISTS ai_recommendations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id UUID REFERENCES organizations(id) ON DELETE CASCADE,
  plot_id UUID REFERENCES plots(id) ON DELETE SET NULL,
  category TEXT NOT NULL,
  title TEXT NOT NULL,
  message TEXT NOT NULL,
  confidence NUMERIC(5,2),
  risk_score NUMERIC(5,2),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS analytics_snapshots (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id UUID REFERENCES organizations(id) ON DELETE CASCADE,
  snapshot_date DATE NOT NULL,
  revenue NUMERIC(14,2),
  yield_t_ha NUMERIC(10,2),
  health_score NUMERIC(5,2),
  active_farms INTEGER,
  pending_approvals INTEGER,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(org_id, snapshot_date)
);

-- Documents and media
CREATE TABLE IF NOT EXISTS documents (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id UUID REFERENCES organizations(id) ON DELETE CASCADE,
  entity_type TEXT,
  entity_id UUID,
  title TEXT,
  file_url TEXT,
  mime_type TEXT,
  uploaded_by UUID REFERENCES profiles(id),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS media_assets (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id UUID REFERENCES organizations(id) ON DELETE CASCADE,
  entity_type TEXT,
  entity_id UUID,
  media_type TEXT CHECK (media_type IN ('image','video','audio','document')),
  storage_url TEXT NOT NULL,
  thumbnail_url TEXT,
  metadata JSONB,
  uploaded_by UUID REFERENCES profiles(id),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Communication and approvals
CREATE TABLE IF NOT EXISTS communication_channels (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id UUID REFERENCES organizations(id) ON DELETE CASCADE,
  channel_name TEXT NOT NULL,
  channel_type TEXT NOT NULL,
  target TEXT,
  status TEXT DEFAULT 'active',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS approval_workflow (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id UUID REFERENCES organizations(id) ON DELETE CASCADE,
  entity_type TEXT NOT NULL,
  entity_id UUID NOT NULL,
  title TEXT NOT NULL,
  requested_by UUID REFERENCES profiles(id),
  approver_id UUID REFERENCES profiles(id),
  status TEXT DEFAULT 'pending',
  comments TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Sync and audit records
CREATE TABLE IF NOT EXISTS sync_log (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id UUID REFERENCES organizations(id) ON DELETE CASCADE,
  sync_type TEXT NOT NULL,
  status TEXT NOT NULL,
  payload JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS audit_log (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id UUID REFERENCES organizations(id) ON DELETE CASCADE,
  user_id UUID REFERENCES profiles(id),
  action TEXT NOT NULL,
  entity_type TEXT,
  entity_id UUID,
  details JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Helpful indexes
CREATE INDEX IF NOT EXISTS idx_farms_org_id ON farms(org_id);
CREATE INDEX IF NOT EXISTS idx_plots_farm_id ON plots(farm_id);
CREATE INDEX IF NOT EXISTS idx_operations_org_id ON operations(org_id);
CREATE INDEX IF NOT EXISTS idx_sensor_data_plot_id ON sensor_data(plot_id);
CREATE INDEX IF NOT EXISTS idx_ai_recommendations_org_id ON ai_recommendations(org_id);
CREATE INDEX IF NOT EXISTS idx_approval_workflow_status ON approval_workflow(status);
CREATE INDEX IF NOT EXISTS idx_sync_log_org_id ON sync_log(org_id);

-- Recommended row level security policies (for Supabase auth)
-- Enable RLS on key tables if needed for app auth
ALTER TABLE organizations ENABLE ROW LEVEL SECURITY;
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE farms ENABLE ROW LEVEL SECURITY;
ALTER TABLE plots ENABLE ROW LEVEL SECURITY;
ALTER TABLE operations ENABLE ROW LEVEL SECURITY;
ALTER TABLE field_observations ENABLE ROW LEVEL SECURITY;
ALTER TABLE sensor_data ENABLE ROW LEVEL SECURITY;
ALTER TABLE purchase_orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE financial_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_recommendations ENABLE ROW LEVEL SECURITY;
ALTER TABLE approval_workflow ENABLE ROW LEVEL SECURITY;
ALTER TABLE sync_log ENABLE ROW LEVEL SECURITY;
ALTER TABLE audit_log ENABLE ROW LEVEL SECURITY;

-- Example policy templates
-- CREATE POLICY "Users can read organizations in their org" ON organizations FOR SELECT USING (true);
-- CREATE POLICY "Users can insert profiles" ON profiles FOR INSERT WITH CHECK (true);

-- Example seed data to support the UI quickly
INSERT INTO organizations (id, name, legal_name, country, region)
VALUES (
  '11111111-1111-1111-1111-111111111111',
  'Sena Agribusiness Group',
  'Sena Agribusiness PLC',
  'Ethiopia',
  'Southern Highlands'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO profiles (id, org_id, full_name, email, role, department)
VALUES (
  '22222222-2222-2222-2222-222222222222',
  '11111111-1111-1111-1111-111111111111',
  'Local Operator',
  'operator@sena.ag',
  'CEO / Admin',
  'Executive'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO farms (id, org_id, name, code, region, country, latitude, longitude, acreage, crop_type, status)
VALUES
  ('33333333-3333-3333-3333-333333333333', '11111111-1111-1111-1111-111111111111', 'Kombolcha Block A', 'SB-001', 'Sidama', 'Ethiopia', 6.6328, 38.3164, 420.00, 'Coffee', 'active'),
  ('44444444-4444-4444-4444-444444444444', '11111111-1111-1111-1111-111111111111', 'Dilla South', 'SB-002', 'Sidama', 'Ethiopia', 6.4126, 38.3149, 260.00, 'Maize', 'monitoring'),
  ('55555555-5555-5555-5555-555555555555', '11111111-1111-1111-1111-111111111111', 'Bule Hora', 'SB-003', 'Bale', 'Ethiopia', 5.5830, 38.9333, 180.00, 'Vegetable', 'active')
ON CONFLICT (id) DO NOTHING;

INSERT INTO approval_workflow (org_id, entity_type, entity_id, title, requested_by, approver_id, status)
VALUES (
  '11111111-1111-1111-1111-111111111111',
  'purchase_order',
  '33333333-3333-3333-3333-333333333333',
  'Seed batch approval',
  '22222222-2222-2222-2222-222222222222',
  '22222222-2222-2222-2222-222222222222',
  'pending'
)
ON CONFLICT DO NOTHING;

-- End of schema
