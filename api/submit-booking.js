// Vercel Serverless Function - Submit Tacky Lights Booking
import { createClient } from '@supabase/supabase-js';

export default async function handler(req, res) {
    // Only allow POST requests
    if (req.method !== 'POST') {
        return res.status(405).json({ error: 'Method not allowed' });
    }

    try {
        const bookingData = req.body;

        // Generate booking reference number
        const bookingRef = generateBookingRef();

        // Add additional metadata
        const enrichedData = {
            ...bookingData,
            booking_ref: bookingRef,
            status: 'new',
            created_at: new Date().toISOString(),
            ip_address: req.headers['x-forwarded-for'] || req.connection.remoteAddress,
            user_agent: req.headers['user-agent']
        };

        // 1. Save to Supabase
        if (process.env.SUPABASE_URL && process.env.SUPABASE_SERVICE_KEY) {
            await saveToSupabase(enrichedData);
        }

        // 2. Send to n8n webhook
        if (process.env.N8N_WEBHOOK_URL) {
            await sendToN8n(enrichedData);
        }

        // 3. Return success response
        return res.status(200).json({
            success: true,
            bookingRef: bookingRef,
            message: 'Booking request received successfully'
        });

    } catch (error) {
        console.error('Booking submission error:', error);
        return res.status(500).json({
            success: false,
            error: 'Failed to process booking request'
        });
    }
}

// Generate unique booking reference (format: TLT-YYYYMMDD-XXXX)
function generateBookingRef() {
    const date = new Date();
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    const random = Math.floor(Math.random() * 10000).toString().padStart(4, '0');

    return `TLT-${year}${month}${day}-${random}`;
}

// Save booking to Supabase
async function saveToSupabase(data) {
    try {
        const supabase = createClient(
            process.env.SUPABASE_URL,
            process.env.SUPABASE_SERVICE_KEY
        );

        const { error } = await supabase
            .from('tacky_lights_leads')
            .insert([{
                booking_ref: data.booking_ref,
                first_name: data.firstName,
                last_name: data.lastName,
                email: data.email,
                phone: data.phone,
                pickup_address: data.pickupAddress,
                tour_date: data.tourDate,
                tour_time: data.tourTime,
                group_size: data.groupSize,
                vehicle_type: data.vehicleType,
                vehicle_key: data.vehicleKey,
                price_quoted: data.priceQuoted,
                special_requests: data.specialRequests,
                hear_about_us: data.hearAboutUs,
                status: data.status,
                lead_source: data.leadSource,
                ip_address: data.ip_address,
                user_agent: data.user_agent,
                created_at: data.created_at
            }]);

        if (error) {
            console.error('Supabase error:', error);
            throw error;
        }

        console.log(`Booking ${data.booking_ref} saved to Supabase`);
    } catch (error) {
        console.error('Failed to save to Supabase:', error);
        // Don't throw - continue with other operations
    }
}

// Send booking to n8n webhook
async function sendToN8n(data) {
    try {
        const response = await fetch(process.env.N8N_WEBHOOK_URL, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                bookingRef: data.booking_ref,
                customer: {
                    firstName: data.firstName,
                    lastName: data.lastName,
                    email: data.email,
                    phone: data.phone
                },
                tourDetails: {
                    date: data.tourDate,
                    time: data.tourTime,
                    pickupAddress: data.pickupAddress,
                    groupSize: data.groupSize,
                    vehicleType: data.vehicleType,
                    vehicleKey: data.vehicleKey
                },
                pricing: {
                    quoted: data.priceQuoted
                },
                metadata: {
                    specialRequests: data.specialRequests,
                    hearAboutUs: data.hearAboutUs,
                    leadSource: data.leadSource,
                    timestamp: data.created_at
                }
            })
        });

        if (!response.ok) {
            throw new Error(`n8n webhook failed: ${response.status}`);
        }

        console.log(`Booking ${data.booking_ref} sent to n8n`);
    } catch (error) {
        console.error('Failed to send to n8n:', error);
        // Don't throw - continue with other operations
    }
}
