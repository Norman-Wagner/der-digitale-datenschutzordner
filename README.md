# NOWA X – Der digitale Datenschutzordner

[![CI](https://github.com/Norman-Wagner/der-digitale-datenschutzordner/actions/workflows/ci.yml/badge.svg)](https://github.com/Norman-Wagner/der-digitale-datenschutzordner/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Status: Alpha](https://img.shields.io/badge/Status-Alpha-orange.svg)](docs/IMPLEMENTATION_REPORT.md)

> **NOWA X** ist ein digitaler Datenschutzordner für kleine und mittlere Unternehmen.  
> Er unterstützt Inhaberinnen und Inhaber sowie Büroleitungen von Bestattungsunternehmen  
> mit 1–10 Filialen und bis zu 25 Mitarbeitenden – ohne eigene Datenschutzfachkraft.

> **Nutzen in den ersten 5 Minuten:** Die Einrichtung zeigt die drei wichtigsten,  
> verständlich formulierten nächsten Schritte. Der Rest läuft im Hintergrund.

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
| 16 | Fahrzeuge & Fahrtenbuch | Vodafone/Driversnote, manuelle Bücher | ✅ |
| 17 | Angehörigenkommunikation | Sicheres Portal, kein WhatsApp-Standard | ✅ |
| 18 | Papierakten & Transport | Filialtransport, 3 Prioritäten, Ausleih | ✅ |

## Bestatter-Branchenvorlagen (vollständig)

```
templates/bestattungsunternehmen/
├── vvt/
│   ├── 01_sterbefallannahme.json          # Erstaufnahme, Angehörigendaten
│   ├── 02_uebernahme_verstorbener.json    # Überführung, Übernahmeprotokoll  
│   ├── 03_hygienische_versorgung.json     # Besondere Kategorie: Gesundheitsdaten
│   ├── 04_kremierung.json                 # Krematoriumsbeauftragung, Urne
│   ├── 05_beisetzung_friedhof.json        # Friedhofsverwaltung, Grabrecht
│   ├── 06_trauerfeier.json                # Technik, Redner, Musik
│   ├── 07_bestattungsvorsorge.json        # Vorsorgevertrag, Datenspeicherung
│   ├── 08_standesamt_formalitaeten.json   # Sterbeurkunde, Totenschein
│   ├── 09_videoüberwachung_geschäftsräume.json
│   └── 10_mitarbeiterdaten_hr.json
├── tom/
│   └── bestatter_tom_katalog.json
├── aufgaben/
│   └── bestatter_aufgabenvorlagen.json
└── dienstleister/
    └── bestatter_dienstleisterkategorien.json
```

## Rollen (Bestattungsunternehmen)

| Rolle | Zugriff |
|-------|--------|
| Inhaber/Geschäftsführung | Vollständige Steuerung |
| Technische Administration | Technisch berechtigt, kein Zugriff auf vertrauliche Inhalte |
| Leitende Angestellte | Zugewiesene Filialen und Aufgaben |
| Büromitarbeitende | Eigene Filialen, zugewiesene Aufgaben |
| Fahrerpersonal | Nur Checklisten und Fahrtenbuch |
| Auszubildende | Klar zugewiesene Checklisten |
| Externe Fachkraft (DSB) | Zeitlich begrenzt, MFA, ohne sensible Anhänge |

## Rechtliche Hinweise

- NOWA X unterstützt die **Dokumentation** von Datenschutzmaßnahmen.
- Es **ersetzt keine Rechtsberatung**.
- Alle Vorlagen sind als Hilfestellung gekennzeichnet und müssen geprüft und freigegeben werden.
- Daten Verstorbener fallen nicht unmittelbar unter die DSGVO – **hohe Schutzstandards gelten dennoch** für jedes Bestattungsunternehmen.
- Die 20-Personen-Schwelle (§ 38 BDSG) ist nur ein Auslöser neben weiteren Kriterien.

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
| [ROADMAP.md](docs/ROADMAP.md) | Entwicklungsplan, 10x-Version |
| [HARDWARE_GUIDE.md](docs/HARDWARE_GUIDE.md) | Hardware-Empfehlungen |
| [IMPLEMENTATION_REPORT.md](docs/IMPLEMENTATION_REPORT.md) | Implementierungsbericht |
| [INTERVIEW_NOTES.md](docs/INTERVIEW_NOTES.md) | Produktinterviews (Stand 14.07.2026) |

## Technologie

- **Frontend:** Next.js 14 (App Router), TypeScript strict, Tailwind CSS, shadcn/ui
- **Backend:** Supabase (PostgreSQL 15, Edge Functions, Storage, Auth)
- **Auth:** Supabase Auth, OIDC (Entra ID), MFA (TOTP, FIDO2 vorbereitet)
- **Desktop:** Tauri 2 (Rust, SQLite+SQLCipher)
- **Tests:** Vitest, Playwright, Supertest
- **CI/CD:** GitHub Actions

---

© 2026 Norman Wagner / wagnerconnect – MIT-Lizenz  
**Stand der Interview-Erkenntnisse: 14. Juli 2026. Noch keine Implementierungsfreigabe für alle Module.**
