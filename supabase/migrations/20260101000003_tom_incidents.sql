-- Migration 003: TOM (Art. 32) und Datenschutzvorfälle (Art. 33/34)

-- ============================================================
-- TECHNISCHE UND ORGANISATORISCHE MAßNAHMEN (Art. 32)
-- ============================================================
CREATE TABLE tom_measures (
  id                UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  tenant_id         UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  branch_id         UUID REFERENCES branches(id),
  title             TEXT NOT NULL,
  category          TEXT NOT NULL,
  -- Vertraulichkeit | Integrität | Verfügbarkeit | Belastbarkeit |
  -- Zutrittskontrolle | Zugangskontrolle | Zugriffskontrolle |
  -- Weitergabekontrolle | Eingabekontrolle | Auftragskontrolle |
  -- Verfügbarkeitskontrolle | Trennungskontrolle | Papier | MobileDevice | Homeoffice
  description       TEXT,
  status            TEXT NOT NULL DEFAULT 'planned',
  -- planned | in_progress | implemented | needs_review | deficient
  affected_systems  TEXT[],
  affected_branches UUID[],
  responsible_id    UUID REFERENCES user_profiles(id),
  implementation_proof TEXT,
  effectiveness_check TEXT,
  last_review_date  DATE,
  next_review_date  DATE,
  deviations        TEXT,
  remediation_task_id UUID,              -- -> tasks.id
  created_by        UUID REFERENCES user_profiles(id),
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_tom_tenant ON tom_measures(tenant_id);
CREATE INDEX idx_tom_status ON tom_measures(status);
CREATE INDEX idx_tom_next_review ON tom_measures(next_review_date);

ALTER TABLE tom_measures ENABLE ROW LEVEL SECURITY;
CREATE POLICY tom_tenant ON tom_measures
  USING (tenant_id = current_tenant_id());

-- ============================================================
-- DATENSCHUTZVORFÄLLE (Art. 33 / 34 DSGVO)
-- ============================================================
CREATE TABLE incidents (
  id                      UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  tenant_id               UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  branch_id               UUID REFERENCES branches(id),
  title                   TEXT NOT NULL,
  description             TEXT,
  discovered_at           TIMESTAMPTZ,
  discovered_by           UUID REFERENCES user_profiles(id),
  -- 72-Stunden-Frist ab Kenntnis
  knowledge_at            TIMESTAMPTZ,
  notification_deadline   TIMESTAMPTZ GENERATED ALWAYS AS
                           (knowledge_at + INTERVAL '72 hours') STORED,
  -- Risikobewertung
  risk_level              TEXT NOT NULL DEFAULT 'not_assessed',
  -- not_assessed | low | medium | high | very_high
  affected_data_categories TEXT[],
  affected_persons_count  INT,
  affected_branches       UUID[],
  affected_systems        TEXT[],
  -- Maßnahmen
  immediate_actions       TEXT,
  root_cause              TEXT,
  -- Meldepflicht
  authority_notification_required BOOLEAN,
  authority_notification_decided_by UUID REFERENCES user_profiles(id),
  authority_notification_decided_at TIMESTAMPTZ,
  authority_notified_at   TIMESTAMPTZ,
  authority_reference     TEXT,
  -- Betroffeneninformation
  persons_notification_required BOOLEAN,
  persons_notified_at     TIMESTAMPTZ,
  -- 4-Augen-Freigabe
  approved_by             UUID REFERENCES user_profiles(id),
  approved_at             TIMESTAMPTZ,
  -- Status
  status                  TEXT NOT NULL DEFAULT 'open',
  -- open | investigating | notified | closed
  closed_at               TIMESTAMPTZ,
  final_report            TEXT,
  created_by              UUID REFERENCES user_profiles(id),
  created_at              TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at              TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_incidents_tenant ON incidents(tenant_id);
CREATE INDEX idx_incidents_status ON incidents(status);
CREATE INDEX idx_incidents_deadline ON incidents(notification_deadline);

ALTER TABLE incidents ENABLE ROW LEVEL SECURITY;
CREATE POLICY incidents_tenant ON incidents
  USING (tenant_id = current_tenant_id());
