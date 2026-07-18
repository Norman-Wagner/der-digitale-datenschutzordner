-- Migration 004: Betroffenenrechte (Art. 15–22 DSGVO)

CREATE TABLE data_subject_requests (
  id                    UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  tenant_id             UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  branch_id             UUID REFERENCES branches(id),
  request_type          TEXT NOT NULL,
  -- access | rectification | erasure | restriction |
  -- portability | objection | automated_decision
  received_at           TIMESTAMPTZ NOT NULL DEFAULT now(),
  channel               TEXT,             -- post | email | in_person | online_form
  requester_name        TEXT,
  requester_contact     TEXT,
  requester_pseudonym   TEXT,             -- wenn Anonymisierung gewünscht
  -- Fristen (Art. 12 Abs. 3: grds. 1 Monat, verlängerbar auf 3)
  response_deadline     DATE GENERATED ALWAYS AS
                         ((received_at + INTERVAL '1 month')::DATE) STORED,
  extended_deadline     DATE,
  extension_reason      TEXT,
  -- Identitätsprüfung
  identity_verified     BOOLEAN NOT NULL DEFAULT false,
  identity_verified_by  UUID REFERENCES user_profiles(id),
  identity_verified_at  TIMESTAMPTZ,
  -- Zuständigkeit
  assigned_to           UUID REFERENCES user_profiles(id),
  affected_branches     UUID[],
  affected_systems      TEXT[],
  -- Workflow
  status                TEXT NOT NULL DEFAULT 'received',
  -- received | identity_check | processing | legal_review | approved | responded | rejected | closed
  legal_review_by       UUID REFERENCES user_profiles(id),
  legal_review_at       TIMESTAMPTZ,
  approved_by           UUID REFERENCES user_profiles(id),
  approved_at           TIMESTAMPTZ,
  -- Antwort
  response_sent_at      TIMESTAMPTZ,
  response_channel      TEXT,
  response_proof        TEXT,             -- Nachweis (Sendebestätigung, Einschreiben ...)
  partial_rejection     BOOLEAN NOT NULL DEFAULT false,
  rejection_reason      TEXT,
  -- Abschluss
  closed_at             TIMESTAMPTZ,
  notes                 TEXT,
  created_by            UUID REFERENCES user_profiles(id),
  created_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at            TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_dsr_tenant ON data_subject_requests(tenant_id);
CREATE INDEX idx_dsr_status ON data_subject_requests(status);
CREATE INDEX idx_dsr_deadline ON data_subject_requests(response_deadline);

-- Aufgaben innerhalb einer Betroffenenanfrage
CREATE TABLE dsr_tasks (
  id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  request_id      UUID NOT NULL REFERENCES data_subject_requests(id) ON DELETE CASCADE,
  title           TEXT NOT NULL,
  description     TEXT,
  assigned_to     UUID REFERENCES user_profiles(id),
  branch_id       UUID REFERENCES branches(id),
  due_date        DATE,
  completed_at    TIMESTAMPTZ,
  completed_by    UUID REFERENCES user_profiles(id),
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_dsr_tasks_request ON dsr_tasks(request_id);

ALTER TABLE data_subject_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE dsr_tasks ENABLE ROW LEVEL SECURITY;

CREATE POLICY dsr_tenant ON data_subject_requests
  USING (tenant_id = current_tenant_id());

CREATE POLICY dsr_tasks_tenant ON dsr_tasks
  USING (
    EXISTS (
      SELECT 1 FROM data_subject_requests dsr
      WHERE dsr.id = request_id AND dsr.tenant_id = current_tenant_id()
    )
  );
