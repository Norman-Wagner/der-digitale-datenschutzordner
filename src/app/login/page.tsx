'use client'

import { useState } from 'react'
import { createClient } from '@/lib/supabase/client'
import { useRouter } from 'next/navigation'

export default function LoginPage() {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState<string | null>(null)
  const [loading, setLoading] = useState(false)
  const router = useRouter()
  const supabase = createClient()

  async function handleLogin(e: React.FormEvent) {
    e.preventDefault()
    setLoading(true)
    setError(null)

    const { error } = await supabase.auth.signInWithPassword({ email, password })

    if (error) {
      setError(error.message)
      setLoading(false)
    } else {
      router.push('/dashboard')
    }
  }

  return (
    <main className="min-h-screen bg-[#f7f6f2] flex items-center justify-center px-4">
      <div className="w-full max-w-sm">
        <div className="text-center mb-8">
          <svg width="48" height="48" viewBox="0 0 32 32" fill="none" className="mx-auto mb-4" aria-label="Logo">
            <rect x="4" y="4" width="24" height="24" rx="4" fill="#01696f" />
            <rect x="9" y="10" width="14" height="2" rx="1" fill="white" />
            <rect x="9" y="15" width="10" height="2" rx="1" fill="white" />
            <rect x="9" y="20" width="12" height="2" rx="1" fill="white" />
          </svg>
          <h1 className="text-2xl font-bold text-[#28251d]">Anmelden</h1>
        </div>

        <form onSubmit={handleLogin} className="bg-[#f9f8f5] rounded-xl p-6 border border-[#dcd9d5] space-y-4">
          {error && (
            <div className="rounded-lg bg-red-50 border border-red-200 p-3 text-sm text-red-700">
              {error}
            </div>
          )}

          <div>
            <label htmlFor="email" className="block text-sm font-medium text-[#28251d] mb-1">
              E-Mail
            </label>
            <input
              id="email"
              type="email"
              required
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              className="w-full rounded-lg border border-[#dcd9d5] bg-white px-3 py-2 text-sm text-[#28251d] placeholder-[#bab9b4] focus:border-[#01696f] focus:outline-none focus:ring-1 focus:ring-[#01696f]"
              placeholder="name@unternehmen.de"
            />
          </div>

          <div>
            <label htmlFor="password" className="block text-sm font-medium text-[#28251d] mb-1">
              Passwort
            </label>
            <input
              id="password"
              type="password"
              required
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              className="w-full rounded-lg border border-[#dcd9d5] bg-white px-3 py-2 text-sm text-[#28251d] placeholder-[#bab9b4] focus:border-[#01696f] focus:outline-none focus:ring-1 focus:ring-[#01696f]"
              placeholder="••••••••"
            />
          </div>

          <button
            type="submit"
            disabled={loading}
            className="w-full rounded-lg bg-[#01696f] py-2.5 text-sm font-medium text-white hover:bg-[#0c4e54] disabled:opacity-50 transition-colors"
          >
            {loading ? 'Wird angemeldet...' : 'Anmelden'}
          </button>
        </form>
      </div>
    </main>
  )
}
