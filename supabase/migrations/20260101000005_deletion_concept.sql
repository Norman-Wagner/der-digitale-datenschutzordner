-- Migration 005: Lösch- und Aufbewahrungskonzept

-- ============================================================
-- LÖSCHREGELN (Datenkategorien mit Fristen)
-- ============================================================
CREATE TABLE deletion_rules (
  id                  UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  tenant_id           UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  branch_id           UUID REFERENCES branches(id),
  data_category       TEXT NOT NULL,
  description         TEXT,
  legal_basis         TEXT,
  retention_period    TEXT NOT NULL,       -- z. B. "10 Jahre", "6 Monate nach Vertragsende"
  retention_start     TEXT,               -- Vertragsende | Letzte Änderung | Geburt ...
  blocking_reasons    TEXT[],             -- Hemmungsgründe (laufendes Verfahren ...)
  deletion_method     TEXT,               -- physisch | Shredder | Überschreiben | krypt. Löschung
  responsible_id      UUID REFERENCES user_profiles(id),
  affected_systems    TEXT[],
  paper_records       BOOLEAN NOT NULL DEFAULT false,
  vvt_ids             UUID[],             -- -> processing_activities.id
  last_review_date    DATE,
  next_review_date    DATE,
  approved_by         UUID REFERENCES user_profiles(id),
  approved_at         TIMESTAMPTZ,
  created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at          TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_dr_tenant ON deletion_rules(tenant_id);

-- ============================================================
-- LÖSCHLÄUFE (Protokoll ausgeführter Löschungen)
-- ============================================================
CREATE TABLE deletion_runs (
  id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  tenant_id       UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  rule_id         UUID REFERENCES deletion_rules(id),
  executed_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
  executed_by     UUID REFERENCES user_profiles(id),
  records_deleted INT,
  method          TEXT,
  notes           TEXT,
  proof_document  TEXT,                   -- Dateiname oder Dokument-ID
  spot_check_done BOOLEAN NOT NULL DEFAULT false,
  spot_check_by   UUID REFERENCES user_profiles(id),
  approved_by     UUID REFERENCES user_profiles(id),
  approved_at     TIMESTAMPTZ
);

CREATE INDEX idx_drun_tenant ON deletion_runs(tenant_id);
CREATE INDEX idx_drun_rule ON deletion_runs(rule_id);

ALTER TABLE deletion_rules ENABLE ROW LEVEL SECURITY;
ALTER TABLE deletion_runs ENABLE ROW LEVEL SECURITY;

CREATE POLICY dr_tenant ON deletion_rules
  USING (tenant_id = current_tenant_id());

CREATE POLICY drun_tenant ON deletion_runs
  USING (tenant_id = current_tenant_id());
