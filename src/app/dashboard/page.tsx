import { redirect } from 'next/navigation'
import { createClient } from '@/lib/supabase/server'

export default async function DashboardPage() {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()

  if (!user) {
    redirect('/login')
  }

  return (
    <main className="min-h-screen bg-[#f7f6f2]">
      <nav className="border-b border-[#dcd9d5] bg-[#f9f8f5]">
        <div className="mx-auto max-w-6xl px-4 py-4 flex items-center justify-between">
          <div className="flex items-center gap-2">
            <svg width="28" height="28" viewBox="0 0 32 32" fill="none" aria-label="Logo">
              <rect x="4" y="4" width="24" height="24" rx="4" fill="#01696f" />
              <rect x="9" y="10" width="14" height="2" rx="1" fill="white" />
              <rect x="9" y="15" width="10" height="2" rx="1" fill="white" />
              <rect x="9" y="20" width="12" height="2" rx="1" fill="white" />
            </svg>
            <span className="font-semibold text-[#28251d]">Datenschutzordner</span>
          </div>
          <span className="text-sm text-[#7a7974]">{user.email}</span>
        </div>
      </nav>

      <div className="mx-auto max-w-6xl px-4 py-12">
        <h1 className="text-2xl font-bold text-[#28251d] mb-8">Dashboard</h1>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 mb-12">
          {[
            { label: 'Verarbeitungstätigkeiten', value: '0', color: '#01696f' },
            { label: 'Offene Aufgaben', value: '0', color: '#964219' },
            { label: 'Datenpannen', value: '0', color: '#a12c7b' },
            { label: 'Betroffenenanfragen', value: '0', color: '#006494' },
          ].map((kpi) => (
            <div key={kpi.label} className="bg-[#f9f8f5] rounded-xl p-5 border border-[#dcd9d5]">
              <p className="text-xs text-[#7a7974] mb-1">{kpi.label}</p>
              <p className="text-3xl font-bold" style={{ color: kpi.color }}>{kpi.value}</p>
            </div>
          ))}
        </div>

        <div className="bg-[#f9f8f5] rounded-xl p-8 border border-[#dcd9d5] text-center">
          <p className="text-[#7a7974] mb-4">Noch keine Daten vorhanden.</p>
          <p className="text-sm text-[#bab9b4]">Wählen Sie eine Branche und importieren Sie die Vorlagen, um zu beginnen.</p>
        </div>
      </div>
    </main>
  )
}
