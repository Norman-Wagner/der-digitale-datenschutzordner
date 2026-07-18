export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  public: {
    Tables: {
      tenants: {
        Row: {
          id: string
          name: string
          legal_form: string | null
          address: string | null
          email: string | null
          phone: string | null
          data_protection_officer: string | null
          industry: string | null
          employee_count: number | null
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          name: string
          legal_form?: string | null
          address?: string | null
          email?: string | null
          phone?: string | null
          data_protection_officer?: string | null
          industry?: string | null
          employee_count?: number | null
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          name?: string
          legal_form?: string | null
          address?: string | null
          email?: string | null
          phone?: string | null
          data_protection_officer?: string | null
          industry?: string | null
          employee_count?: number | null
          created_at?: string
          updated_at?: string
        }
      }
      branches: {
        Row: {
          id: string
          tenant_id: string
          name: string
          address: string | null
          is_headquarters: boolean
          created_at: string
        }
        Insert: {
          id?: string
          tenant_id: string
          name: string
          address?: string | null
          is_headquarters?: boolean
          created_at?: string
        }
        Update: {
          id?: string
          tenant_id?: string
          name?: string
          address?: string | null
          is_headquarters?: boolean
          created_at?: string
        }
      }
      processing_activities: {
        Row: {
          id: string
          tenant_id: string
          branch_id: string | null
          name: string
          purpose: string | null
          legal_basis: string | null
          data_categories: string[] | null
          data_subjects: string[] | null
          retention_period: string | null
          third_country_transfer: boolean
          status: string
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          tenant_id: string
          branch_id?: string | null
          name: string
          purpose?: string | null
          legal_basis?: string | null
          data_categories?: string[] | null
          data_subjects?: string[] | null
          retention_period?: string | null
          third_country_transfer?: boolean
          status?: string
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          tenant_id?: string
          branch_id?: string | null
          name?: string
          purpose?: string | null
          legal_basis?: string | null
          data_categories?: string[] | null
          data_subjects?: string[] | null
          retention_period?: string | null
          third_country_transfer?: boolean
          status?: string
          created_at?: string
          updated_at?: string
        }
      }
    }
    Views: Record<string, never>
    Functions: Record<string, never>
    Enums: Record<string, never>
  }
}
