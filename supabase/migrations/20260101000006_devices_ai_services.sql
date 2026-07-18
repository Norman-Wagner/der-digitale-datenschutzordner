-- Migration 006: Geräte-/Anlagenregister und KI-Dienste-Verzeichnis

-- ============================================================
-- GERÄTE- UND ANLAGENREGISTER
-- ============================================================
CREATE TABLE devices (
  id                    UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  tenant_id             UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  branch_id             UUID REFERENCES branches(id),
  -- Stammdaten
  label                 TEXT NOT NULL,
  category              TEXT NOT NULL,
  -- workstation | notebook | tablet | smartphone | server | nas |
  -- router | printer | scanner | camera | external_drive | usb_drive |
  -- security_key | access_card | gateway | other
  manufacturer          TEXT,
  model                 TEXT,
  serial_number         TEXT,
  inventory_number      TEXT,
  -- Zuordnung
  owner_user_id         UUID REFERENCES user_profiles(id),
  responsible_user_id   UUID REFERENCES user_profiles(id),
  location              TEXT,
  issued_at             DATE,
  returned_at           DATE,
  -- Sicherheit
  os_firmware           TEXT,
  encrypted             BOOLEAN,
  screen_lock           BOOLEAN,
  mfa_enabled           BOOLEAN,
  admin_rights          BOOLEAN NOT NULL DEFAULT false,
  accesses_personal_data BOOLEAN NOT NULL DEFAULT false,
  processing_activity_ids UUID[],          -- -> processing_activities.id
  tom_ids               UUID[],           -- -> tom_measures.id
  -- Zustand
  status                TEXT NOT NULL DEFAULT 'active',
  -- active | issued | lost | stolen | in_repair | decommissioned
  last_security_check   DATE,
  next_security_check   DATE,
  known_issues          TEXT,
  incident_id           UUID,             -- -> incidents.id bei Verlust/Vorfall
  -- Aussonderung
  decommissioned_at     DATE,
  deletion_proof        TEXT,
  created_by            UUID REFERENCES user_profiles(id),
  created_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at            TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_devices_tenant ON devices(tenant_id);
CREATE INDEX idx_devices_status ON devices(status);
CREATE INDEX idx_devices_next_check ON devices(next_security_check);

ALTER TABLE devices ENABLE ROW LEVEL SECURITY;
CREATE POLICY devices_tenant ON devices
  USING (tenant_id = current_tenant_id());

-- ============================================================
-- KI-DIENSTE-VERZEICHNIS
-- ============================================================
CREATE TABLE ai_services (
  id                    UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  tenant_id             UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  name                  TEXT NOT NULL,
  provider              TEXT,
  purpose               TEXT,
  affected_branches     UUID[],
  using_departments     TEXT[],
  authorized_users      UUID[],           -- -> user_profiles.id
  -- Datenkategorien
  input_data_types      TEXT[],
  contains_personal_data BOOLEAN NOT NULL DEFAULT false,
  contains_special_categories BOOLEAN NOT NULL DEFAULT false,
  prohibited_inputs     TEXT,
  -- Nutzung und Kontrolle
  result_usage          TEXT,
  human_oversight       BOOLEAN NOT NULL DEFAULT true,
  automated_decisions   BOOLEAN NOT NULL DEFAULT false,
  automated_decision_basis TEXT,
  -- Anbieter-Verarbeitung
  provider_trains_on_data BOOLEAN,
  provider_retention    TEXT,
  data_location         TEXT,
  data_recipients       TEXT[],
  -- Auftragsverarbeitung
  processor_agreement   BOOLEAN NOT NULL DEFAULT false,
  avv_id                UUID,            -- -> service_providers.id
  sub_processors        TEXT[],
  third_country_transfer BOOLEAN NOT NULL DEFAULT false,
  transfer_guarantee    TEXT,
  -- Status
  status                TEXT NOT NULL DEFAULT 'draft',
  -- draft | in_review | approved | suspended
  risk_level            TEXT NOT NULL DEFAULT 'not_assessed',
  approved_by           UUID REFERENCES user_profiles(id),
  approved_at           TIMESTAMPTZ,
  next_review_date      DATE,
  created_by            UUID REFERENCES user_profiles(id),
  created_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at            TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_ai_tenant ON ai_services(tenant_id);
CREATE INDEX idx_ai_status ON ai_services(status);

ALTER TABLE ai_services ENABLE ROW LEVEL SECURITY;
CREATE POLICY ai_tenant ON ai_services
  USING (tenant_id = current_tenant_id());

-- ============================================================
-- AUDIT-TABELLE (Append-only für alle kritischen Änderungen)
-- ============================================================
CREATE TABLE audit_log (
  id            UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  tenant_id     UUID NOT NULL,
  branch_id     UUID,
  user_id       UUID,
  action        TEXT NOT NULL,            -- INSERT | UPDATE | DELETE | APPROVE | EXPORT ...
  table_name    TEXT NOT NULL,
  record_id     UUID,
  old_value     JSONB,
  new_value     JSONB,
  change_reason TEXT,
  ip_address    INET,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Audit-Tabelle ist nur INSERT, kein UPDATE/DELETE erlaubt
ALTER TABLE audit_log ENABLE ROW LEVEL SECURITY;

CREATE POLICY audit_insert_only ON audit_log
  FOR INSERT WITH CHECK (tenant_id = current_tenant_id());

CREATE POLICY audit_read ON audit_log
  FOR SELECT USING (tenant_id = current_tenant_id());

-- Kein UPDATE und DELETE auf audit_log (Append-only Sicherheit)
CREATE RULE no_update_audit AS ON UPDATE TO audit_log DO INSTEAD NOTHING;
CREATE RULE no_delete_audit AS ON DELETE TO audit_log DO INSTEAD NOTHING;

CREATE INDEX idx_audit_tenant ON audit_log(tenant_id);
CREATE INDEX idx_audit_table ON audit_log(table_name);
CREATE INDEX idx_audit_record ON audit_log(record_id);
CREATE INDEX idx_audit_created ON audit_log(created_at);
