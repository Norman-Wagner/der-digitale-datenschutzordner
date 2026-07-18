-- Migration 002: VVT – Verzeichnis von Verarbeitungstätigkeiten (Art. 30 DSGVO)

-- ============================================================
-- VERARBEITUNGSTÄTIGKEITEN
-- ============================================================
CREATE TABLE processing_activities (
  id                    UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  tenant_id             UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  branch_id             UUID REFERENCES branches(id),        -- NULL = mandantenweite VVT
  title                 TEXT NOT NULL,
  purpose               TEXT,
  description           TEXT,
  -- Personengruppen und Datenkategorien
  data_subjects         TEXT[],                              -- Betroffene Personengruppen
  data_categories       TEXT[],                              -- Datenkategorien
  special_categories    TEXT[],                              -- Besondere Kategorien Art. 9
  special_categories_basis TEXT,                             -- Rechtsgrundlage Art. 9
  -- Rechtsgrundlage
  legal_basis           TEXT[],                              -- Art. 6 Abs. 1 DSGVO
  legal_basis_notes     TEXT,                                -- Begründung
  legitimate_interest   TEXT,                                -- Bei lit. f: Interessenabwägung
  -- Quellen und Empfänger
  data_sources          TEXT[],
  recipients_internal   TEXT[],
  recipients_external   JSONB,                               -- [{name, role, country}]
  -- Auftragsverarbeiter
  processors            UUID[],                              -- -> service_providers.id
  joint_controllers     JSONB,                               -- [{name, agreement_ref}]
  -- Drittland
  third_country_transfer BOOLEAN NOT NULL DEFAULT false,
  third_country_details  JSONB,                              -- [{country, guarantee, basis}]
  -- Fristen
  retention_period      TEXT,
  retention_basis       TEXT,
  deletion_method       TEXT,
  -- TOM
  tom_summary           TEXT,
  tom_ids               UUID[],                              -- -> tom_measures.id
  -- Systeme
  system_ids            UUID[],                              -- -> devices.id
  -- Verantwortung
  responsible_user_id   UUID REFERENCES user_profiles(id),
  responsible_unit      TEXT,
  -- Status und Versionierung
  status                TEXT NOT NULL DEFAULT 'draft',
  -- draft | in_review | approved | needs_revision | archived
  dsfa_required         TEXT NOT NULL DEFAULT 'not_assessed',
  -- not_assessed | no | yes_pending | yes_completed
  dsfa_id               UUID,                                -- -> dsfa_assessments.id
  version               INT NOT NULL DEFAULT 1,
  version_notes         TEXT,
  approved_by           UUID REFERENCES user_profiles(id),
  approved_at           TIMESTAMPTZ,
  next_review_date      DATE,
  -- Metadaten
  created_by            UUID REFERENCES user_profiles(id),
  created_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at            TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_pa_tenant ON processing_activities(tenant_id);
CREATE INDEX idx_pa_branch ON processing_activities(branch_id);
CREATE INDEX idx_pa_status ON processing_activities(status);
CREATE INDEX idx_pa_next_review ON processing_activities(next_review_date);

-- Versionshistorie (Append-only)
CREATE TABLE processing_activity_versions (
  id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  activity_id     UUID NOT NULL REFERENCES processing_activities(id) ON DELETE CASCADE,
  version         INT NOT NULL,
  snapshot        JSONB NOT NULL,              -- vollständiger Datensatz
  changed_by      UUID REFERENCES user_profiles(id),
  changed_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  change_reason   TEXT
);

CREATE INDEX idx_pav_activity ON processing_activity_versions(activity_id);

-- RLS
ALTER TABLE processing_activities ENABLE ROW LEVEL SECURITY;
ALTER TABLE processing_activity_versions ENABLE ROW LEVEL SECURITY;

CREATE POLICY pa_tenant ON processing_activities
  USING (tenant_id = current_tenant_id());

CREATE POLICY pav_tenant ON processing_activity_versions
  USING (
    EXISTS (
      SELECT 1 FROM processing_activities pa
      WHERE pa.id = activity_id AND pa.tenant_id = current_tenant_id()
    )
  );
