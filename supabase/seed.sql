-- Seed: Demonstrationsdaten (NUR Entwicklung/Staging – KEINE Produktionsdaten)
-- Alle Namen und Daten sind fiktiv.

-- Hinweis: Wird nur ausgeführt wenn SUPABASE_ENV != 'production'

DO $$
BEGIN
  IF current_setting('app.environment', true) = 'production' THEN
    RAISE EXCEPTION 'Seed darf nicht auf Produktionsdatenbank ausgeführt werden.';
  END IF;
END $$;

-- Demo-Mandant
INSERT INTO tenants (id, name, slug, legal_form, industry) VALUES
  ('00000000-0000-0000-0000-000000000001', 'Musterbetrieb GmbH', 'musterbetrieb', 'GmbH', 'allgemein');

-- Demo-Filialen
INSERT INTO branches (id, tenant_id, name, is_headquarter) VALUES
  ('00000000-0000-0000-0001-000000000001', '00000000-0000-0000-0000-000000000001', 'Hauptsitz', true),
  ('00000000-0000-0000-0001-000000000002', '00000000-0000-0000-0000-000000000001', 'Filiale Nord', false);
