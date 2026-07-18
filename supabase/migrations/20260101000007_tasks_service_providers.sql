-- Migration 007: Aufgaben/Fristen und Dienstleister/AV-Verträge

-- ============================================================
-- AUFGABEN UND FRISTEN
-- ============================================================
CREATE TABLE tasks (
  id                UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  tenant_id         UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  branch_id         UUID REFERENCES branches(id),
  title             TEXT NOT NULL,
  description       TEXT,
  -- Kontext (Verknüpfung mit Fachmodulen)
  module            TEXT,
  -- vvt | tom | incident | dsr | deletion | dsfa | document | general
  related_record_id UUID,
  -- Verantwortung
  assigned_to       UUID REFERENCES user_profiles(id),
  deputy_id         UUID REFERENCES user_profiles(id),
  -- Frist
  due_date          DATE,
  priority          TEXT NOT NULL DEFAULT 'normal',
  -- low | normal | high | critical
  -- Wiederholung
  recurring         BOOLEAN NOT NULL DEFAULT false,
  recurrence_rule   TEXT,
  -- daily | weekly | monthly | quarterly | yearly
  recurrence_end    DATE,
  parent_task_id    UUID REFERENCES tasks(id),
  -- Status
  status            TEXT NOT NULL DEFAULT 'open',
  -- open | in_progress | waiting_approval | done | overdue | cancelled
  completed_at      TIMESTAMPTZ,
  completed_by      UUID REFERENCES user_profiles(id),
  completion_proof  TEXT,
  -- 4-Augen-Freigabe
  requires_approval BOOLEAN NOT NULL DEFAULT false,
  approved_by       UUID REFERENCES user_profiles(id),
  approved_at       TIMESTAMPTZ,
  -- Eskalation
  escalation_days   INT,                 -- nach X Tagen Überfälligkeit eskalieren
  escalated_to      UUID REFERENCES user_profiles(id),
  created_by        UUID REFERENCES user_profiles(id),
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_tasks_tenant ON tasks(tenant_id);
CREATE INDEX idx_tasks_status ON tasks(status);
CREATE INDEX idx_tasks_due ON tasks(due_date);
CREATE INDEX idx_tasks_assigned ON tasks(assigned_to);

ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;
CREATE POLICY tasks_tenant ON tasks
  USING (tenant_id = current_tenant_id());

-- ============================================================
-- DIENSTLEISTER UND AV-VERTRÄGE
-- ============================================================
CREATE TABLE service_providers (
  id                  UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  tenant_id           UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  name                TEXT NOT NULL,
  category            TEXT,               -- Software | IT | Buchhaltung | Reinigung ...
  website             TEXT,
  address             JSONB,
  contact_person      TEXT,
  contact_email       TEXT,
  contact_phone       TEXT,
  -- Rolle nach Datenschutzrecht
  legal_role          TEXT NOT NULL DEFAULT 'unclear',
  -- processor | joint_controller | independent_controller | unclear
  -- Verarbeitung
  processing_description TEXT,
  data_categories     TEXT[],
  data_location       TEXT,
  third_country       BOOLEAN NOT NULL DEFAULT false,
  third_country_guarantee TEXT,
  sub_processors      JSONB,             -- [{name, country, purpose}]
  -- Betroffene Filialen
  branch_ids          UUID[],
  -- Risikobewertung
  risk_level          TEXT NOT NULL DEFAULT 'not_assessed',
  last_audit_date     DATE,
  next_audit_date     DATE,
  known_issues        TEXT,
  -- Status
  status              TEXT NOT NULL DEFAULT 'active',
  -- active | suspended | terminated
  created_by          UUID REFERENCES user_profiles(id),
  created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at          TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_sp_tenant ON service_providers(tenant_id);
CREATE INDEX idx_sp_status ON service_providers(status);

-- AV-Verträge (versioniert)
CREATE TABLE avv_contracts (
  id                  UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  tenant_id           UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  provider_id         UUID NOT NULL REFERENCES service_providers(id) ON DELETE CASCADE,
  title               TEXT NOT NULL,
  version             INT NOT NULL DEFAULT 1,
  signed_at           DATE,
  valid_from          DATE,
  valid_until         DATE,
  termination_notice  TEXT,
  file_path           TEXT,              -- Supabase Storage Pfad
  file_checksum       TEXT,             -- SHA-256
  status              TEXT NOT NULL DEFAULT 'draft',
  -- draft | active | expired | terminated
  notes               TEXT,
  approved_by         UUID REFERENCES user_profiles(id),
  approved_at         TIMESTAMPTZ,
  created_by          UUID REFERENCES user_profiles(id),
  created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at          TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_avv_tenant ON avv_contracts(tenant_id);
CREATE INDEX idx_avv_provider ON avv_contracts(provider_id);
CREATE INDEX idx_avv_status ON avv_contracts(status);

ALTER TABLE service_providers ENABLE ROW LEVEL SECURITY;
ALTER TABLE avv_contracts ENABLE ROW LEVEL SECURITY;

CREATE POLICY sp_tenant ON service_providers
  USING (tenant_id = current_tenant_id());

CREATE POLICY avv_tenant ON avv_contracts
  USING (tenant_id = current_tenant_id());
