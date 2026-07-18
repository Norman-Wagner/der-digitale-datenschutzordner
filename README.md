# NOWA X – Der digitale Datenschutzordner

[![CI](https://github.com/Norman-Wagner/der-digitale-datenschutzordner/actions/workflows/ci.yml/badge.svg)](https://github.com/Norman-Wagner/der-digitale-datenschutzordner/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Status: Alpha](https://img.shields.io/badge/Status-Alpha-orange.svg)](docs/IMPLEMENTATION_REPORT.md)

> **NOWA X** ist ein digitaler Datenschutzordner für kleine und mittlere Unternehmen –  
> unabhängig davon, ob der Betrieb überwiegend digital, papierbasiert, online, offline  
> oder mit mehreren räumlich getrennten Filialen arbeitet.

> **Kein Sechs-Wochen-Zwang.** Alle Module sind sofort und frei zugänglich.  
> Ein optionaler geführter Einrichtungsassistent ist verfügbar, aber keine Voraussetzung.

---

## Schnellstart

```bash
git clone https://github.com/Norman-Wagner/der-digitale-datenschutzordner.git
cd der-digitale-datenschutzordner
npm install
cp .env.example .env.local
# Supabase-URL und Anon-Key eintragen
npm run dev
```

## Nutzungsarten

| Modus | Beschreibung |
|-------|--------------|
| **Freier Datenschutzordner** | Alle Module sofort erreichbar – kein Assistent, keine Pflichtphasen |
| **Geführte Einrichtung** | Optionaler Schritt-für-Schritt-Assistent (mit oder ohne Zeitvorgabe) |

Der geführte Modus kann jederzeit verlassen und später fortgesetzt werden.  
Er ist eine Hilfestellung – keine technische Voraussetzung.

## Betriebsarten

| Modus | Beschreibung | Status |
|-------|--------------|--------|
| **Online (Cloud)** | Browser, Supabase-Backend, EU-Hosting | ✅ Implementiert |
| **Desktop (Windows)** | Tauri 2, SQLite+SQLCipher, Offline-Sync | 🔧 Vorbereitet |
| **Lokal (Einzelplatz)** | Vollständig offline, keine Cloud | 🔧 Vorbereitet |

## Fachmodule

| # | Modul | Beschreibung | Status |
|---|-------|--------------|--------|
| 1 | Unternehmen & Organisation | Mandanten, Filialen, Rollen, DSB-Pflicht-Check | ✅ |
| 2 | Bestandsaufnahme | Systeme, Geräte, Papierakten, BYOD | ✅ |
| 3 | VVT | Verarbeitungstätigkeiten (Art. 30 DSGVO) | ✅ |
| 4 | TOM | Technische & Organisatorische Maßnahmen | ✅ |
| 5 | Dienstleister & AV-Verträge | AVV, Unterauftragnehmer, Drittland | ✅ |
| 6 | Betroffenenrechte | Auskunft, Löschung, Fristberechnung | ✅ |
| 7 | Datenschutzvorfälle | 72h-Frist, 4-Augen-Freigabe, Vorakte | ✅ |
| 8 | Lösch- & Aufbewahrungskonzept | Löschläufe, Protokolle | ✅ |
| 9 | DSFA | Folgenabschätzung, Risikoermittlung | ✅ |
| 10 | Richtlinien & Schulungen | Kenntnisnahmen, Rollen, Wiederholung | ✅ |
| 11 | Aufgaben & Fristen | Wiederkehrend, Eskalation, 4-Augen | ✅ |
| 12 | Audit & Versionen | Append-only, Prüfsummen, ZIP-Dossier | ✅ |
| 13 | Geräte- & Anlagenregister | BYOD, Ausgabe, Verlust, Aussonderung | ✅ |
| 14 | KI-Dienste-Verzeichnis | Freigabe, Risiko, AVV-Status | ✅ |
| 15 | Sicherheits-Schnellcheck | 35 Fragen, Aufgaben, TOM-Vorschläge | ✅ |
| 16 | Papierakten & Transport | Filialtransport, Prioritäten, Ausleih | ✅ |

## Branchenvorlagen

Branchenvorlagen sind **optional** und klar als Hilfestellung gekennzeichnet.  
Sie enthalten VVT-Entwürfe, TOM-Vorschläge, Dienstleisterkategorien und Aufgabenvorlagen.  
Alle Vorlagen müssen geprüft, angepasst und freigegeben werden – sie ersetzen keine Fachberatung.

Verfügbare Branchenvorlagen:

| Branche | Pfad | Status |
|---------|------|--------|
| Bestattungsunternehmen | `templates/bestattungsunternehmen/` | ✅ Vollständig |
| Floristik | `templates/floristik/` | 🔧 Vorbereitet |
| Steinmetzbetriebe | `templates/steinmetz/` | 🔧 Vorbereitet |
| Pflegeeinrichtungen | `templates/pflege/` | 🔧 Vorbereitet |
| Handwerksbetriebe | `templates/handwerk/` | 🔧 Vorbereitet |
| Sonstige Unternehmen | `templates/sonstige/` | 🔧 Vorbereitet |

## Rollen

| Rolle | Zugriff |
|-------|--------|
| Inhaber / Geschäftsführung | Vollständige Steuerung aller Filialen |
| Technische Administration | Technisch berechtigt, kein Zugriff auf vertrauliche Inhalte |
| Datenschutzkoordinator | Filialübergreifend, alle Datenschutzmodule |
| Leitende Angestellte | Zugewiesene Filialen und Aufgaben |
| Büromitarbeitende | Eigene Filialen, zugewiesene Aufgaben |
| Externe Fachkraft (DSB) | Zeitlich begrenzt, MFA, ohne sensible Anhänge |

## Mehrfilialbetrieb

Unternehmen mit mehreren Filialen ohne gemeinsames lokales Netzwerk werden vollständig unterstützt:

- Filialbezogene Nutzerrechte und Datentrennung
- Zentrale Dokumente und lokale Abweichungen
- Filialübergreifende Auswertung für Geschäftsführung und Datenschutzkoordination
- Kein Zugriff auf fremde Filialen ohne ausdrückliche Berechtigung

## Rechtliche Hinweise

- NOWA X unterstützt die **Dokumentation** von Datenschutzmaßnahmen.
- Es **ersetzt keine Rechtsberatung** und behauptet keine automatische DSGVO-Konformität.
- Alle Vorlagen sind als Hilfestellung gekennzeichnet und müssen geprüft und freigegeben werden.
- Rechtlich oder fachlich relevante Entscheidungen müssen einer verantwortlichen Person zugeordnet und dokumentiert sein.

## Dokumentation

| Dokument | Inhalt |
|----------|--------|
| [PRODUCT_SPEC.md](docs/PRODUCT_SPEC.md) | Vollständige Produktspezifikation |
| [ARCHITECTURE.md](docs/ARCHITECTURE.md) | Systemarchitektur, ADRs |
| [DATABASE.md](docs/DATABASE.md) | Datenbankschema, RLS |
| [SECURITY.md](docs/SECURITY.md) | Sicherheitskonzept |
| [OFFLINE_SYNC.md](docs/OFFLINE_SYNC.md) | Offline & Synchronisation |
| [DEPLOYMENT_MODES.md](docs/DEPLOYMENT_MODES.md) | Betriebsarten |
| [TEST_STRATEGY.md](docs/TEST_STRATEGY.md) | Teststrategie |
| [ROADMAP.md](docs/ROADMAP.md) | Entwicklungsplan |
| [HARDWARE_GUIDE.md](docs/HARDWARE_GUIDE.md) | Hardware-Empfehlungen |
| [IMPLEMENTATION_REPORT.md](docs/IMPLEMENTATION_REPORT.md) | Implementierungsbericht |

## Technologie

- **Frontend:** Next.js 14 (App Router), TypeScript strict, Tailwind CSS, shadcn/ui
- **Backend:** Supabase (PostgreSQL 15, Edge Functions, Storage, Auth)
- **Auth:** Supabase Auth, OIDC (Entra ID), MFA (TOTP, FIDO2 vorbereitet)
- **Desktop:** Tauri 2 (Rust, SQLite+SQLCipher)
- **Tests:** Vitest, Playwright, Supertest
- **CI/CD:** GitHub Actions

---

© 2026 Norman Wagner / wagnerconnect – MIT-Lizenz  
**Hinweis: Alpha-Stand. Noch keine vollständige Implementierungsfreigabe für alle Module.**
