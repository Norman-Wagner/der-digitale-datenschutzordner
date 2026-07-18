import Link from 'next/link'

export default function HomePage() {
  return (
    <main className="min-h-screen bg-[#f7f6f2]">
      {/* Navigation */}
      <nav className="border-b border-[#dcd9d5] bg-[#f9f8f5]">
        <div className="mx-auto max-w-6xl px-4 py-4 flex items-center justify-between">
          <div className="flex items-center gap-2">
            <svg width="32" height="32" viewBox="0 0 32 32" fill="none" aria-label="Datenschutzordner Logo">
              <rect x="4" y="4" width="24" height="24" rx="4" fill="#01696f" />
              <rect x="9" y="10" width="14" height="2" rx="1" fill="white" />
              <rect x="9" y="15" width="10" height="2" rx="1" fill="white" />
              <rect x="9" y="20" width="12" height="2" rx="1" fill="white" />
            </svg>
            <span className="font-semibold text-[#28251d]">Digitaler Datenschutzordner</span>
          </div>
          <div className="flex items-center gap-4">
            <Link href="/login" className="text-sm text-[#7a7974] hover:text-[#28251d] transition-colors">
              Anmelden
            </Link>
            <Link
              href="/login"
              className="rounded-lg bg-[#01696f] px-4 py-2 text-sm font-medium text-white hover:bg-[#0c4e54] transition-colors"
            >
              Kostenlos starten
            </Link>
          </div>
        </div>
      </nav>

      {/* Hero */}
      <section className="mx-auto max-w-4xl px-4 py-24 text-center">
        <h1 className="text-4xl font-bold text-[#28251d] mb-6 leading-tight">
          DSGVO-Compliance für KMU
          <br />
          <span className="text-[#01696f]">branchenspezifisch & einfach</span>
        </h1>
        <p className="text-lg text-[#7a7974] mb-10 max-w-2xl mx-auto">
          Der einzige Datenschutzordner mit vorgefertigten Vorlagen für Ihre Branche.
          Kein Jurist nötig — in 30 Minuten DSGVO-konform.
        </p>
        <Link
          href="/login"
          className="inline-block rounded-lg bg-[#01696f] px-8 py-3 text-base font-medium text-white hover:bg-[#0c4e54] transition-colors"
        >
          Jetzt kostenlos testen
        </Link>
      </section>

      {/* Features */}
      <section className="mx-auto max-w-6xl px-4 py-16">
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
          <div className="bg-[#f9f8f5] rounded-xl p-6 border border-[#dcd9d5]">
            <h3 className="font-semibold text-[#28251d] mb-2">Branchenvorlagen</h3>
            <p className="text-sm text-[#7a7974]">
              Vorlagen für Bestattungsunternehmen, Ärzte, Anwälte und mehr —
              sofort einsatzbereit.
            </p>
          </div>
          <div className="bg-[#f9f8f5] rounded-xl p-6 border border-[#dcd9d5]">
            <h3 className="font-semibold text-[#28251d] mb-2">Automatische Fristen</h3>
            <p className="text-sm text-[#7a7974]">
              Aufgaben mit DSGVO-Fristen werden automatisch erstellt und
              erinnern Sie rechtzeitig.
            </p>
          </div>
          <div className="bg-[#f9f8f5] rounded-xl p-6 border border-[#dcd9d5]">
            <h3 className="font-semibold text-[#28251d] mb-2">Mandantenfähig</h3>
            <p className="text-sm text-[#7a7974]">
              Perfekt für Datenschutzbeauftragte: Verwalten Sie mehrere
              Unternehmen in einer Ansicht.
            </p>
          </div>
        </div>
      </section>
    </main>
  )
}
