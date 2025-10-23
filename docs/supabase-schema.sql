-- ============================================================================
-- TNT Tacky Lights Booking System - Supabase Database Schema
-- ============================================================================
-- Run this in Supabase SQL Editor to create tables and security policies
-- Dashboard → SQL Editor → New Query → Paste → Run
-- ============================================================================

-- Drop existing tables if they exist (CAREFUL IN PRODUCTION!)
-- DROP TABLE IF EXISTS tacky_lights_leads CASCADE;
-- DROP TABLE IF EXISTS quick_quotes CASCADE;

-- ============================================================================
-- Main Leads Table (Full booking requests with customer info)
-- ============================================================================
CREATE TABLE IF NOT EXISTS tacky_lights_leads (
    -- Primary Key
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Booking Reference (Unique identifier for customer)
    booking_ref TEXT UNIQUE NOT NULL,

    -- Customer Information
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT NOT NULL,
    phone TEXT NOT NULL,
    pickup_address TEXT NOT NULL,

    -- Tour Details
    tour_date DATE NOT NULL,
    tour_time TEXT NOT NULL,
    group_size INTEGER NOT NULL CHECK (group_size > 0 AND group_size <= 50),

    -- Vehicle Selection
    vehicle_type TEXT NOT NULL,
    vehicle_key TEXT NOT NULL,
    price_quoted DECIMAL(10, 2) NOT NULL,

    -- Additional Info
    special_requests TEXT,
    hear_about_us TEXT,

    -- Lead Management
    status TEXT DEFAULT 'new' CHECK (status IN ('new', 'contacted', 'quoted', 'booked', 'cancelled', 'completed')),
    lead_source TEXT DEFAULT 'website',

    -- Tracking & Analytics
    ip_address TEXT,
    user_agent TEXT,

    -- Timestamps
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    contacted_at TIMESTAMP WITH TIME ZONE,
    booked_at TIMESTAMP WITH TIME ZONE,

    -- Sales Assignment
    assigned_to UUID REFERENCES auth.users(id),

    -- Notes from sales team
    internal_notes TEXT
);

-- ============================================================================
-- Quick Quotes Table (Anonymous quote requests - no customer info yet)
-- ============================================================================
CREATE TABLE IF NOT EXISTS quick_quotes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Quote Details
    vehicle_type TEXT NOT NULL,
    vehicle_key TEXT NOT NULL,
    tour_date DATE NOT NULL,
    group_size INTEGER NOT NULL,
    price_quoted DECIMAL(10, 2) NOT NULL,

    -- Tracking
    converted_to_lead BOOLEAN DEFAULT FALSE,
    lead_id UUID REFERENCES tacky_lights_leads(id),

    -- Analytics
    ip_address TEXT,
    user_agent TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================================================
-- Indexes for Performance
-- ============================================================================
CREATE INDEX IF NOT EXISTS idx_leads_email ON tacky_lights_leads(email);
CREATE INDEX IF NOT EXISTS idx_leads_phone ON tacky_lights_leads(phone);
CREATE INDEX IF NOT EXISTS idx_leads_tour_date ON tacky_lights_leads(tour_date);
CREATE INDEX IF NOT EXISTS idx_leads_status ON tacky_lights_leads(status);
CREATE INDEX IF NOT EXISTS idx_leads_created_at ON tacky_lights_leads(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_leads_booking_ref ON tacky_lights_leads(booking_ref);
CREATE INDEX IF NOT EXISTS idx_quotes_created_at ON quick_quotes(created_at DESC);

-- ============================================================================
-- Row Level Security (RLS) Policies
-- ============================================================================

-- Enable RLS on both tables
ALTER TABLE tacky_lights_leads ENABLE ROW LEVEL SECURITY;
ALTER TABLE quick_quotes ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- LEADS TABLE POLICIES
-- ============================================================================

-- Policy 1: Allow PUBLIC to INSERT leads (booking form submissions)
CREATE POLICY "Allow public insert on leads"
ON tacky_lights_leads
FOR INSERT
TO public
WITH CHECK (true);

-- Policy 2: Allow PUBLIC to SELECT their own leads (by email for confirmation)
CREATE POLICY "Allow users to view their own leads"
ON tacky_lights_leads
FOR SELECT
TO public
USING (email = current_setting('request.jwt.claims', true)::json->>'email');

-- Policy 3: Allow AUTHENTICATED users (TNT staff) to SELECT all leads
CREATE POLICY "Allow authenticated users to view all leads"
ON tacky_lights_leads
FOR SELECT
TO authenticated
USING (true);

-- Policy 4: Allow AUTHENTICATED users to UPDATE all leads
CREATE POLICY "Allow authenticated users to update leads"
ON tacky_lights_leads
FOR UPDATE
TO authenticated
USING (true)
WITH CHECK (true);

-- Policy 5: Allow service_role to do everything (for API functions)
CREATE POLICY "Allow service_role full access to leads"
ON tacky_lights_leads
FOR ALL
TO service_role
USING (true)
WITH CHECK (true);

-- ============================================================================
-- QUICK QUOTES TABLE POLICIES
-- ============================================================================

-- Policy 1: Allow PUBLIC to INSERT anonymous quotes
CREATE POLICY "Allow public insert on quotes"
ON quick_quotes
FOR INSERT
TO public
WITH CHECK (true);

-- Policy 2: Allow AUTHENTICATED users to SELECT all quotes
CREATE POLICY "Allow authenticated users to view all quotes"
ON quick_quotes
FOR SELECT
TO authenticated
USING (true);

-- Policy 3: Allow service_role full access
CREATE POLICY "Allow service_role full access to quotes"
ON quick_quotes
FOR ALL
TO service_role
USING (true)
WITH CHECK (true);

-- ============================================================================
-- Trigger: Auto-update updated_at timestamp
-- ============================================================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_leads_updated_at
BEFORE UPDATE ON tacky_lights_leads
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================
-- Useful Views for Analytics
-- ============================================================================

-- View: Recent leads (last 30 days)
CREATE OR REPLACE VIEW recent_leads AS
SELECT
    booking_ref,
    first_name || ' ' || last_name AS customer_name,
    email,
    phone,
    tour_date,
    vehicle_type,
    price_quoted,
    status,
    created_at
FROM tacky_lights_leads
WHERE created_at >= NOW() - INTERVAL '30 days'
ORDER BY created_at DESC;

-- View: Conversion funnel (quotes vs booked)
CREATE OR REPLACE VIEW conversion_stats AS
SELECT
    COUNT(*) FILTER (WHERE status = 'new') as new_leads,
    COUNT(*) FILTER (WHERE status = 'contacted') as contacted_leads,
    COUNT(*) FILTER (WHERE status = 'quoted') as quoted_leads,
    COUNT(*) FILTER (WHERE status = 'booked') as booked_leads,
    COUNT(*) FILTER (WHERE status = 'cancelled') as cancelled_leads,
    ROUND(
        COUNT(*) FILTER (WHERE status = 'booked')::DECIMAL /
        NULLIF(COUNT(*), 0) * 100,
        2
    ) as conversion_rate
FROM tacky_lights_leads
WHERE created_at >= NOW() - INTERVAL '30 days';

-- View: Revenue by vehicle type
CREATE OR REPLACE VIEW revenue_by_vehicle AS
SELECT
    vehicle_type,
    COUNT(*) as bookings,
    SUM(price_quoted) as total_revenue,
    AVG(price_quoted) as avg_price
FROM tacky_lights_leads
WHERE status IN ('booked', 'completed')
GROUP BY vehicle_type
ORDER BY total_revenue DESC;

-- ============================================================================
-- Grant permissions to views
-- ============================================================================
GRANT SELECT ON recent_leads TO authenticated;
GRANT SELECT ON conversion_stats TO authenticated;
GRANT SELECT ON revenue_by_vehicle TO authenticated;

-- ============================================================================
-- Sample Data (Optional - for testing)
-- ============================================================================
-- Uncomment to insert test data

/*
INSERT INTO tacky_lights_leads (
    booking_ref, first_name, last_name, email, phone,
    pickup_address, tour_date, tour_time, group_size,
    vehicle_type, vehicle_key, price_quoted, status, lead_source
) VALUES (
    'TLT-20251223-0001',
    'John',
    'Smith',
    'john.smith@example.com',
    '(804) 555-1234',
    '1234 Main St, Richmond, VA 23220',
    '2025-12-20',
    '18:00',
    4,
    'Suburban',
    'suburban',
    589.00,
    'new',
    'website'
);
*/

-- ============================================================================
-- Setup Complete!
-- ============================================================================
-- Next steps:
-- 1. Copy your Supabase URL and keys to .env file
-- 2. Configure Row Level Security as needed
-- 3. Set up n8n webhook to receive new leads
-- 4. Deploy to Vercel
-- ============================================================================
