# n8n Webhook Setup Guide for TNT Tacky Lights Bookings

> **No coding required!** This guide uses simple screenshots and step-by-step instructions.

## 📋 What You're Building

When someone submits a booking request on your website, this n8n workflow will automatically:
1. ✅ Save the lead to your Supabase database
2. ✉️ Email the customer a confirmation with quote details
3. 📞 Email your team a notification to follow up
4. 📊 (Optional) Add the lead to Zoho CRM

---

## 🚀 Quick Setup (5 Minutes)

### Step 1: Create New Workflow

1. Log in to n8n Cloud: https://app.n8n.cloud/
2. Click **"+ New Workflow"** button (top right)
3. Name it: **"TNT Tacky Lights - Lead Capture"**

---

### Step 2: Add Webhook Node (Receives Form Data)

**What this does:** Creates a URL that receives booking requests from your website

#### Instructions:
1. Click the **"+"** button in the workflow canvas
2. Search for **"Webhook"** and click it
3. Configure the webhook:
   - **HTTP Method:** `POST`
   - **Path:** `tacky-lights-leads`
   - **Authentication:** `None` (for now)

4. **IMPORTANT:** Click **"Listen for Test Event"** button
5. **Copy the webhook URL** - It looks like:
   ```
   https://your-n8n-instance.app.n8n.cloud/webhook/tacky-lights-leads
   ```
6. Save this URL - you'll add it to your Vercel environment variables later

---

### Step 3: Add Supabase Node (Save to Database)

**What this does:** Saves the booking request to your database

#### Instructions:
1. Click the **"+"** button after the Webhook node
2. Search for **"Supabase"** and click it
3. Configure:
   - **Credential:** Click "+ Create New Credential"
     - **Host:** `https://your-project.supabase.co` (from Supabase dashboard)
     - **Service Role Key:** Get from Supabase → Project Settings → API
   - **Operation:** `Insert`
   - **Table:** `tacky_lights_leads`

4. **Map the fields** (drag from left to right):
   ```
   booking_ref      → {{ $json.bookingRef }}
   first_name       → {{ $json.customer.firstName }}
   last_name        → {{ $json.customer.lastName }}
   email            → {{ $json.customer.email }}
   phone            → {{ $json.customer.phone }}
   pickup_address   → {{ $json.tourDetails.pickupAddress }}
   tour_date        → {{ $json.tourDetails.date }}
   tour_time        → {{ $json.tourDetails.time }}
   group_size       → {{ $json.tourDetails.groupSize }}
   vehicle_type     → {{ $json.tourDetails.vehicleType }}
   vehicle_key      → {{ $json.tourDetails.vehicleKey }}
   price_quoted     → {{ $json.pricing.quoted }}
   special_requests → {{ $json.metadata.specialRequests }}
   hear_about_us    → {{ $json.metadata.hearAboutUs }}
   lead_source      → {{ $json.metadata.leadSource }}
   status           → new
   ```

---

### Step 4: Add Email Node (Customer Confirmation)

**What this does:** Sends a confirmation email to the customer

#### Instructions:
1. Click **"+"** after Supabase node
2. Search for **"Send Email"** (or "Gmail" / "SendGrid")
3. Configure:
   - **To:** `{{ $json.customer.email }}`
   - **From:** `bookings@tntlimousine.com` (your email)
   - **Subject:** `Your TNT Tacky Lights Tour Quote - {{ $json.bookingRef }}`
   - **Email Type:** `HTML`
   - **Body:** Copy the template below ⬇️

#### Customer Email Template:
```html
<div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; background: #f5f5f5; padding: 20px;">
    <div style="background: #0a0a0a; padding: 30px; text-align: center; border-radius: 10px 10px 0 0;">
        <h1 style="color: #C41E3A; margin: 0;">TNT Limousine</h1>
        <p style="color: white; margin: 10px 0 0 0;">Richmond Tacky Lights Tours</p>
    </div>

    <div style="background: white; padding: 30px; border-radius: 0 0 10px 10px;">
        <h2 style="color: #4CAF50; margin-top: 0;">✅ Quote Request Received!</h2>

        <p>Hi {{ $json.customer.firstName }},</p>

        <p>Thank you for requesting a quote for our TNT Tacky Lights Tour! Here are your details:</p>

        <div style="background: #f9f9f9; padding: 20px; border-left: 4px solid #C41E3A; margin: 20px 0;">
            <p style="margin: 5px 0;"><strong>Booking Reference:</strong> {{ $json.bookingRef }}</p>
            <p style="margin: 5px 0;"><strong>Tour Date:</strong> {{ $json.tourDetails.date }}</p>
            <p style="margin: 5px 0;"><strong>Pickup Time:</strong> {{ $json.tourDetails.time }}</p>
            <p style="margin: 5px 0;"><strong>Group Size:</strong> {{ $json.tourDetails.groupSize }} passengers</p>
            <p style="margin: 5px 0;"><strong>Vehicle:</strong> {{ $json.tourDetails.vehicleType }}</p>
            <p style="margin: 5px 0;"><strong>Pickup Location:</strong> {{ $json.tourDetails.pickupAddress }}</p>
        </div>

        <div style="background: #e8f5e9; padding: 15px; border-radius: 8px; margin: 20px 0;">
            <h3 style="color: #2e7d32; margin-top: 0;">Your Quote: ${{ $json.pricing.quoted }}</h3>
            <p style="margin: 5px 0; font-size: 14px;">3-hour tour including professional chauffeur, gratuity, and fuel</p>
        </div>

        <h3 style="color: #C41E3A;">What's Next?</h3>
        <ol style="line-height: 1.8;">
            <li>A TNT team member will contact you within 4 business hours to confirm availability</li>
            <li>For same-day bookings, we'll respond immediately at (804) 972-4550</li>
            <li>Start planning your route with our free guides (links below)</li>
        </ol>

        <div style="background: #f5f5f5; padding: 20px; border-radius: 8px; margin: 20px 0;">
            <h4 style="margin-top: 0;">📍 Free Tacky Lights Resources</h4>
            <p><a href="https://tntlimousine.com/tacky-lights-guide" style="color: #C41E3A;">Download Driver's Insider Guide (61 locations)</a></p>
            <p><a href="https://tntlimousine.com/tacky-lights-checklist" style="color: #C41E3A;">Get Printable Checklist</a></p>
            <p><a href="https://tntlimousine.com/tacky-lights-map" style="color: #C41E3A;">View Interactive Map</a></p>
        </div>

        <p><strong>Questions?</strong><br>
        Call: (804) 972-4550<br>
        Email: info@tntlimousine.com</p>

        <p style="font-size: 12px; color: #666; margin-top: 30px; border-top: 1px solid #ddd; padding-top: 15px;">
            TNT Limousine • Richmond, VA • 25+ Years of Excellence
        </p>
    </div>
</div>
```

---

### Step 5: Add Email Node (Team Notification)

**What this does:** Alerts your team about the new booking

#### Instructions:
1. Click **"+"** after the customer email node
2. Add another **"Send Email"** node
3. Configure:
   - **To:** `dispatch@tntlimousine.com` (your team email)
   - **From:** `bookings@tntlimousine.com`
   - **Subject:** `🚨 NEW Tacky Lights Lead - {{ $json.bookingRef }}`
   - **Body:** Copy template below ⬇️

#### Team Notification Template:
```html
<div style="font-family: Arial, sans-serif; max-width: 600px;">
    <h2 style="color: #C41E3A;">🎄 New Tacky Lights Tour Request</h2>

    <div style="background: #fff3cd; padding: 15px; border-left: 4px solid #ffc107; margin: 20px 0;">
        <p style="margin: 0;"><strong>⚡ ACTION REQUIRED:</strong> Contact within 4 hours</p>
    </div>

    <h3>Customer Information</h3>
    <table style="width: 100%; border-collapse: collapse;">
        <tr>
            <td style="padding: 8px; border-bottom: 1px solid #ddd;"><strong>Name:</strong></td>
            <td style="padding: 8px; border-bottom: 1px solid #ddd;">{{ $json.customer.firstName }} {{ $json.customer.lastName }}</td>
        </tr>
        <tr>
            <td style="padding: 8px; border-bottom: 1px solid #ddd;"><strong>Email:</strong></td>
            <td style="padding: 8px; border-bottom: 1px solid #ddd;">{{ $json.customer.email }}</td>
        </tr>
        <tr>
            <td style="padding: 8px; border-bottom: 1px solid #ddd;"><strong>Phone:</strong></td>
            <td style="padding: 8px; border-bottom: 1px solid #ddd;">{{ $json.customer.phone }}</td>
        </tr>
    </table>

    <h3>Tour Details</h3>
    <table style="width: 100%; border-collapse: collapse;">
        <tr>
            <td style="padding: 8px; border-bottom: 1px solid #ddd;"><strong>Date:</strong></td>
            <td style="padding: 8px; border-bottom: 1px solid #ddd;">{{ $json.tourDetails.date }}</td>
        </tr>
        <tr>
            <td style="padding: 8px; border-bottom: 1px solid #ddd;"><strong>Time:</strong></td>
            <td style="padding: 8px; border-bottom: 1px solid #ddd;">{{ $json.tourDetails.time }}</td>
        </tr>
        <tr>
            <td style="padding: 8px; border-bottom: 1px solid #ddd;"><strong>Pickup:</strong></td>
            <td style="padding: 8px; border-bottom: 1px solid #ddd;">{{ $json.tourDetails.pickupAddress }}</td>
        </tr>
        <tr>
            <td style="padding: 8px; border-bottom: 1px solid #ddd;"><strong>Group Size:</strong></td>
            <td style="padding: 8px; border-bottom: 1px solid #ddd;">{{ $json.tourDetails.groupSize }} passengers</td>
        </tr>
        <tr>
            <td style="padding: 8px; border-bottom: 1px solid #ddd;"><strong>Vehicle:</strong></td>
            <td style="padding: 8px; border-bottom: 1px solid #ddd;">{{ $json.tourDetails.vehicleType }}</td>
        </tr>
        <tr>
            <td style="padding: 8px; border-bottom: 1px solid #ddd;"><strong>Quote:</strong></td>
            <td style="padding: 8px; border-bottom: 1px solid #ddd;"><strong style="color: #4CAF50; font-size: 18px;">${{ $json.pricing.quoted }}</strong></td>
        </tr>
    </table>

    <h3>Additional Info</h3>
    <p><strong>Special Requests:</strong><br>{{ $json.metadata.specialRequests || "None" }}</p>
    <p><strong>How they heard about us:</strong> {{ $json.metadata.hearAboutUs }}</p>

    <div style="background: #C41E3A; color: white; padding: 20px; margin: 30px 0; border-radius: 8px; text-align: center;">
        <p style="margin: 0; font-size: 18px;"><strong>Booking Reference:</strong></p>
        <p style="margin: 10px 0 0 0; font-size: 24px; font-family: monospace;">{{ $json.bookingRef }}</p>
    </div>

    <p><strong>📅 Next Steps:</strong></p>
    <ol>
        <li>Call customer at {{ $json.customer.phone }}</li>
        <li>Verify vehicle availability for {{ $json.tourDetails.date }}</li>
        <li>Confirm pickup location and route preferences</li>
        <li>Send final booking confirmation</li>
        <li>Add to dispatch calendar</li>
    </ol>
</div>
```

---

### Step 6: Activate the Workflow

1. Click **"Save"** button (top right)
2. Toggle the workflow **ON** (switch at top)
3. **Copy your webhook URL** from Step 2

---

## 🔗 Connect to Your Website

### Add Webhook URL to Vercel

1. Go to your Vercel project: https://vercel.com/dashboard
2. Select your **tnt-tacky-lights-quote-tool** project
3. Go to **Settings** → **Environment Variables**
4. Add new variable:
   - **Name:** `N8N_WEBHOOK_URL`
   - **Value:** Your webhook URL from Step 2
   - Click **Save**

5. **Redeploy** your project for changes to take effect

---

## ✅ Testing Your Setup

### Test the Full Flow

1. Go to your booking form: https://your-site.vercel.app
2. Fill out the form with test data
3. Submit the booking

**You should receive:**
- ✅ Customer confirmation email
- ✅ Team notification email
- ✅ New row in Supabase `tacky_lights_leads` table
- ✅ Success page with booking reference

---

## 🎯 Optional: Add Zoho CRM Integration

If you want leads automatically added to Zoho CRM:

1. In your workflow, click **"+"** after the Supabase node
2. Search for **"Zoho CRM"** and add it
3. Configure:
   - **Resource:** `Lead`
   - **Operation:** `Create`
   - **Map fields:**
     - First Name: `{{ $json.customer.firstName }}`
     - Last Name: `{{ $json.customer.lastName }}`
     - Email: `{{ $json.customer.email }}`
     - Phone: `{{ $json.customer.phone }}`
     - Company: `{{ $json.customer.firstName }} {{ $json.customer.lastName }}`
     - Lead Source: `Website - Tacky Lights Form`

---

## 📊 View Your Leads in Supabase

1. Go to Supabase Dashboard
2. Click **Table Editor** → `tacky_lights_leads`
3. See all booking requests in real-time!

---

## 🆘 Troubleshooting

### Webhook not receiving data?
- Check that workflow is activated (ON)
- Verify webhook URL is correct in Vercel environment variables
- Check n8n execution log for errors

### Emails not sending?
- Verify email credentials in n8n
- Check spam folder
- Test email node separately in n8n

### Supabase not saving data?
- Verify Supabase URL and service key
- Check RLS policies allow insert
- View Supabase logs for errors

---

## 📞 Need Help?

If you get stuck, you can:
1. Check n8n execution history (shows what failed)
2. View Supabase logs
3. Contact me for support

---

**Setup complete! 🎉**

Your booking system is now fully automated and ready to capture tacky lights tour leads!