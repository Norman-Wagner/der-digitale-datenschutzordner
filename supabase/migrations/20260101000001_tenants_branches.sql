-- Migration 001: Mandanten, Unternehmen, Filialen
-- NOWA X – Kern-Infrastruktur für Mehrfilialbetrieb

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ============================================================
-- MANDANTEN (Unternehmen als technisch getrennte Einheiten)
-- ============================================================
CREATE TABLE tenants (
  id            UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name          TEXT NOT NULL,
  slug          TEXT NOT NULL UNIQUE,
  legal_form    TEXT,                    -- GmbH, e.K., GbR ...
  industry      TEXT,                    -- allgemein / bestattung / pflege ...
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  deleted_at    TIMESTAMPTZ             -- Soft-Delete
);

-- ============================================================
-- FILIALEN / BETRIEBSSTÄTTEN
-- ============================================================
CREATE TABLE branches (
  id            UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  tenant_id     UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  name          TEXT NOT NULL,
  address       JSONB,                   -- {street, city, zip, country}
  phone         TEXT,
  email         TEXT,
  is_headquarter BOOLEAN NOT NULL DEFAULT false,
  active        BOOLEAN NOT NULL DEFAULT true,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_branches_tenant ON branches(tenant_id);

-- ============================================================
-- BENUTZER (erweitertes Profil zu auth.users)
-- ============================================================
CREATE TABLE user_profiles (
  id            UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  tenant_id     UUID NOT NULL REFERENCES tenants(id),
  full_name     TEXT,
  role          TEXT NOT NULL DEFAULT 'staff',
  -- Röllen: owner | admin | coordinator | manager | staff | driver | trainee | external_dsb
  mfa_required  BOOLEAN NOT NULL DEFAULT false,
  active        BOOLEAN NOT NULL DEFAULT true,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_user_profiles_tenant ON user_profiles(tenant_id);

-- ============================================================
-- FILIALBERECHTIGUNG (Nutzer <-> Filiale, granular)
-- ============================================================
CREATE TABLE branch_permissions (
  id            UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id       UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
  branch_id     UUID NOT NULL REFERENCES branches(id) ON DELETE CASCADE,
  access_level  TEXT NOT NULL DEFAULT 'read',
  -- read | write | approve | admin
  granted_by    UUID REFERENCES user_profiles(id),
  granted_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  expires_at    TIMESTAMPTZ,
  UNIQUE (user_id, branch_id)
);

CREATE INDEX idx_branch_perm_user ON branch_permissions(user_id);
CREATE INDEX idx_branch_perm_branch ON branch_permissions(branch_id);

-- ============================================================
-- HILFSFUNKTIONEN FÜR RLS
-- ============================================================
CREATE OR REPLACE FUNCTION current_tenant_id()
RETURNS UUID LANGUAGE sql STABLE SECURITY DEFINER AS $$
  SELECT tenant_id FROM user_profiles WHERE id = auth.uid()
$$;

CREATE OR REPLACE FUNCTION has_branch_access(p_branch_id UUID, p_level TEXT DEFAULT 'read')
RETURNS BOOLEAN LANGUAGE sql STABLE SECURITY DEFINER AS $$
  SELECT EXISTS (
    SELECT 1 FROM branch_permissions
    WHERE user_id   = auth.uid()
      AND branch_id = p_branch_id
      AND (access_level = p_level OR access_level = 'admin'
           OR (p_level = 'read' AND access_level IN ('read','write','approve','admin'))
           OR (p_level = 'write' AND access_level IN ('write','approve','admin'))
           OR (p_level = 'approve' AND access_level IN ('approve','admin')))
      AND (expires_at IS NULL OR expires_at > now())
  )
$$;

-- ============================================================
-- ROW LEVEL SECURITY
-- ============================================================
ALTER TABLE tenants ENABLE ROW LEVEL SECURITY;
ALTER TABLE branches ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE branch_permissions ENABLE ROW LEVEL SECURITY;

-- Mandanten: nur eigener Mandant sichtbar
CREATE POLICY tenants_isolation ON tenants
  USING (id = current_tenant_id());

-- Filialen: nur Filialen des eigenen Mandanten
CREATE POLICY branches_isolation ON branches
  USING (tenant_id = current_tenant_id());

-- Nutzerprofile: nur eigener Mandant
CREATE POLICY profiles_isolation ON user_profiles
  USING (tenant_id = current_tenant_id());

-- Filialberechtigung: eigene Einträge oder Admin des Mandanten
CREATE POLICY branch_perm_isolation ON branch_permissions
  USING (
    user_id = auth.uid()
    OR EXISTS (
      SELECT 1 FROM user_profiles
      WHERE id = auth.uid()
        AND tenant_id = current_tenant_id()
        AND role IN ('owner','admin')
    )
  );
