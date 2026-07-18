import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
  title: 'Der Digitale Datenschutzordner',
  description: 'DSGVO-Compliance-Software für KMU - branchenspezifisch, einfach, rechtssicher',
  keywords: ['DSGVO', 'Datenschutz', 'Compliance', 'KMU', 'Datenschutzordner'],
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="de">
      <body className={inter.className}>{children}</body>
    </html>
  )
}
