# TNT Tacky Lights Quote Tool - Complete Setup Guide

> **Production-ready booking system for Richmond Tacky Lights Tours**
>
> **Time to deploy:** 30-45 minutes | **Cost:** $0 (free tier everything)

---

## 📦 What's Included

This is a complete, production-ready booking system with:

✅ **Live Pricing Calculator** - Instant quotes based on date, group size, vehicle
✅ **Smart Vehicle Recommendations** - Auto-suggests best vehicle for group size
✅ **Address Autocomplete** - Powered by Radar API (100k free requests/month)
✅ **Lead Magnets** - Popup with free guides, checklists, maps
✅ **Automated Workflows** - n8n integration for email & CRM
✅ **Database Storage** - Supabase with Row Level Security
✅ **Mobile-First Design** - Looks great on all devices
✅ **TNT Branding** - Black & red theme matching your brand

---

## 🎯 Quick Start Checklist

Follow these steps in order:

- [ ] **Step 1:** Set up Supabase (database)
- [ ] **Step 2:** Set up n8n (automation)
- [ ] **Step 3:** Get Radar API key (address autocomplete)
- [ ] **Step 4:** Deploy to Vercel (hosting)
- [ ] **Step 5:** Configure environment variables
- [ ] **Step 6:** Test the full workflow
- [ ] **Step 7:** Go live!

**Total time:** ~45 minutes

---

## 📋 Prerequisites

You'll need accounts on these services (all have generous free tiers):

| Service | Purpose | Cost | Sign Up Link |
|---------|---------|------|--------------|
| **Supabase** | Database storage | FREE | https://supabase.com/dashboard |
| **n8n Cloud** | Workflow automation | FREE | https://app.n8n.cloud/ |
| **Radar** | Address autocomplete | FREE | https://radar.com/ |
| **Vercel** | Website hosting | FREE | https://vercel.com/ |
| **GitHub** | Code repository | FREE | Already set up! |

**Free tier limits (more than enough):**
- Supabase: 500MB database, unlimited API requests
- n8n: 5,000 workflow executions/month
- Radar: 100,000 requests/month
- Vercel: Unlimited bandwidth

---

## 🗂️ Step 1: Set Up Supabase (Database)

### 1.1 Create Supabase Project

1. Go to https://supabase.com/dashboard
2. Click **"New Project"**
3. Fill in:
   - **Name:** `tnt-tacky-lights`
   - **Database Password:** (choose a strong password - SAVE THIS!)
   - **Region:** `East US (North Virginia)` (closest to Richmond)
4. Click **"Create new project"**
5. Wait 2-3 minutes for setup

### 1.2 Run Database Schema

1. In Supabase dashboard, click **SQL Editor** (left sidebar)
2. Click **"New Query"**
3. Open `docs/supabase-schema.sql` from this repo
4. Copy the entire file and paste into the query editor
5. Click **"Run"** (bottom right)
6. You should see: ✅ Success. No rows returned

**What this creates:**
- `tacky_lights_leads` table (stores bookings)
- `quick_quotes` table (anonymous quotes)
- Security policies (Row Level Security)
- Useful analytics views

### 1.3 Get Your API Keys

1. In Supabase, go to **Settings** → **API**
2. Copy these (you'll need them later):
   - **Project URL:** `https://xxxxx.supabase.co`
   - **anon/public key:** `eyJhbGciOiJIUzI1NiIsInR5cCI...`
   - **service_role key:** `eyJhbGciOiJIUzI1NiIsInR5cCI...` ⚠️ Keep secret!

---

## 🤖 Step 2: Set Up n8n (Automation)

### 2.1 Create n8n Workflow

Follow the detailed guide: **`docs/N8N-SETUP-GUIDE.md`**

**Quick summary:**
1. Create new workflow: "TNT Tacky Lights - Lead Capture"
2. Add Webhook node → Copy webhook URL
3. Add Supabase node → Insert data
4. Add 2x Email nodes → Customer + team notifications
5. Activate workflow

### 2.2 Save Your Webhook URL

You'll get a URL like:
```
https://your-instance.app.n8n.cloud/webhook/tacky-lights-leads
```

**Save this URL** - you'll add it to Vercel in Step 5.

---

## 🌍 Step 3: Get Radar API Key (Address Autocomplete)

### 3.1 Sign Up for Radar

1. Go to https://radar.com/
2. Click **"Start for Free"**
3. Create account (no credit card required)
4. Verify your email

### 3.2 Create Project & Get API Key

1. In Radar dashboard, click **"Create Project"**
2. Name: `TNT Limousine`
3. Go to **Settings** → **API Keys**
4. Copy your **Publishable Key**: `prj_live_pk_...`

**Free tier:** 100,000 requests/month (enough for ~3,000 bookings)

---

## 🚀 Step 4: Deploy to Vercel

### 4.1 Connect GitHub to Vercel

1. Go to https://vercel.com/new
2. Click **"Import Git Repository"**
3. Select: `sperry-entelech/tnt-tacky-lights-quote-tool`
4. Click **"Import"**

### 4.2 Configure Project

1. **Project Name:** `tnt-tacky-lights-quote-tool`
2. **Framework Preset:** Leave as "Other"
3. **Root Directory:** `./`
4. **Build Command:** Leave empty
5. Click **"Deploy"**

⏱️ Wait 2-3 minutes for initial deployment

---

## 🔐 Step 5: Configure Environment Variables

### 5.1 Add Environment Variables to Vercel

1. In Vercel dashboard, go to your project
2. Click **Settings** → **Environment Variables**
3. Add these variables (one by one):

| Variable Name | Value | Where to Get It |
|---------------|-------|-----------------|
| `SUPABASE_URL` | `https://xxxxx.supabase.co` | Supabase → Settings → API |
| `SUPABASE_SERVICE_KEY` | `eyJhbGciOiJIUzI1NiIsInR5cCI...` | Supabase → Settings → API |
| `N8N_WEBHOOK_URL` | `https://your-n8n.app.n8n.cloud/webhook/...` | From Step 2 |
| `RADAR_API_KEY` | `prj_live_pk_...` | Radar dashboard |

⚠️ **Important:** Make sure all variables are set to **Production**, **Preview**, and **Development**

### 5.2 Redeploy

1. Go to **Deployments** tab
2. Click **"..."** on latest deployment → **"Redeploy"**
3. Click **"Redeploy"** again to confirm

---

## ✅ Step 6: Test Your Setup

### 6.1 Test the Booking Form

1. Visit your Vercel URL: `https://tnt-tacky-lights-quote-tool.vercel.app`
2. Fill out the booking form with test data:
   - **Name:** Test User
   - **Email:** your-email@example.com (use your real email to get confirmation)
   - **Phone:** (804) 555-1234
   - **Date:** Select any future date
   - **Group Size:** 4
   - **Vehicle:** Select "Suburban"
3. Submit the form

### 6.2 Verify Everything Works

You should see:

✅ **Success Page** - With booking reference (e.g., `TLT-20251223-1234`)

✅ **Customer Email** - Check your inbox for confirmation email

✅ **Team Email** - Check dispatch email for notification

✅ **Supabase** - Go to Supabase → Table Editor → `tacky_lights_leads` → See new row

✅ **n8n** - Go to n8n → Workflow → Executions → See successful run

---

## 🎉 Step 7: Go Live!

### 7.1 Add Custom Domain (Optional)

1. In Vercel, go to **Settings** → **Domains**
2. Add: `tacky-lights.tntlimousine.com` (or your preferred subdomain)
3. Follow Vercel's DNS instructions

### 7.2 Update Lead Magnet Links

Edit `index.html` and `success.html` to add real links to your guides:

```javascript
// Find these lines and update with real URLs:
<a href="#" class="popup-link" target="_blank">
    📍 Driver's Insider Guide - All 61 Locations
</a>

// Change to:
<a href="https://tntlimousine.com/guides/tacky-lights-drivers-guide.pdf" class="popup-link" target="_blank">
    📍 Driver's Insider Guide - All 61 Locations
</a>
```

### 7.3 Add Tracking (Optional)

Add Google Analytics or Facebook Pixel for conversion tracking:

1. Edit `success.html`
2. Find the `<script>` section at the bottom
3. Add your tracking code:

```javascript
// Google Analytics
gtag('event', 'conversion', {
    'send_to': 'AW-XXXXXXXXX/XXXXXX',
    'value': 1.0,
    'currency': 'USD'
});

// Facebook Pixel
fbq('track', 'Lead', {
    value: {{ price }},
    currency: 'USD'
});
```

---

## 📊 How to Use Your Dashboard

### View Leads in Supabase

1. Go to Supabase → **Table Editor**
2. Click **`tacky_lights_leads`**
3. See all booking requests in real-time

**Useful filters:**
- Status = 'new' → Uncontacted leads
- Created today → Today's bookings
- Tour date → Upcoming tours

### View Analytics

Supabase has pre-built views:

1. **recent_leads** - Last 30 days
2. **conversion_stats** - Booking conversion rate
3. **revenue_by_vehicle** - Which vehicles are most popular

Access in SQL Editor:
```sql
SELECT * FROM recent_leads;
SELECT * FROM conversion_stats;
SELECT * FROM revenue_by_vehicle;
```

---

## 🔧 Customization Options

### Change Pricing

Edit `index.html` around line 300:

```javascript
const vehiclePricing = {
    'lincoln-aviator': {
        name: 'Lincoln Aviator',
        passengers: 3,
        weekdayPrice: 300,  // ← Change this
        weekendPrice: 375,  // ← Change this
        hourlyRate: 100
    },
    // ... more vehicles
};
```

### Change Email Templates

Edit email HTML in `docs/N8N-SETUP-GUIDE.md`, then update your n8n workflow.

### Add More Vehicles

Add to the `vehiclePricing` object in `index.html`.

---

## 🆘 Troubleshooting

### Form Not Submitting

**Symptom:** Button disabled or spinner never stops

**Fix:**
1. Open browser console (F12 → Console)
2. Look for errors
3. Check that all environment variables are set in Vercel
4. Verify API endpoint: `https://your-site.vercel.app/api/submit-booking`

### No Confirmation Email

**Symptom:** Form submits but no email received

**Fix:**
1. Check spam/junk folder
2. Verify n8n workflow is activated (ON)
3. Check n8n execution log for errors
4. Test email node separately in n8n

### Supabase Not Saving Data

**Symptom:** Leads not appearing in database

**Fix:**
1. Check Supabase → Logs for errors
2. Verify RLS policies allow INSERT
3. Check that `SUPABASE_SERVICE_KEY` is set (not anon key)
4. Run schema SQL again if needed

### Address Autocomplete Not Working

**Symptom:** No suggestions when typing address

**Fix:**
1. Check that `RADAR_API_KEY` is set in Vercel
2. Verify API key is active in Radar dashboard
3. Check browser console for 403/401 errors
4. Try typing a full address (needs 3+ characters)

---

## 📞 Support

### Self-Service Resources

- **Supabase Docs:** https://supabase.com/docs
- **n8n Docs:** https://docs.n8n.io/
- **Vercel Docs:** https://vercel.com/docs
- **Radar Docs:** https://radar.com/documentation

### File Structure Reference

```
tnt-tacky-lights-quote-tool/
├── index.html              ← Main booking form
├── success.html            ← Confirmation page
├── package.json            ← Dependencies
├── vercel.json             ← Vercel config
├── .env.example            ← Environment variable template
├── api/
│   └── submit-booking.js   ← Serverless function
├── assets/
│   ├── tnt-logo.png        ← Your logo
│   └── tacky-lights-data.json ← 61 locations
└── docs/
    ├── supabase-schema.sql     ← Database setup
    ├── N8N-SETUP-GUIDE.md      ← Workflow instructions
    └── SETUP-GUIDE.md          ← This file!
```

---

## 🚀 Next Steps

Once your system is live:

1. **Monitor Performance**
   - Check Supabase daily for new leads
   - Review n8n execution log for failures
   - Track conversion rate

2. **Optimize**
   - A/B test different vehicle recommendations
   - Adjust email templates based on customer feedback
   - Add more lead magnets (videos, virtual tours)

3. **Scale**
   - Upgrade to paid tiers when you exceed free limits
   - Add SMS notifications (Twilio)
   - Integrate payment processing (Stripe)

---

## 📈 Recommended Upgrades

As you grow, consider:

### For High Volume (500+ bookings/month):
- **Supabase Pro:** $25/month (8GB database)
- **n8n Cloud Starter:** $20/month (10k executions)
- **Radar Growth:** $49/month (1M requests)

### For Better Conversions:
- **SendGrid Essentials:** $15/month (better email deliverability)
- **Twilio SMS:** ~$0.0075/msg (instant booking confirmations)
- **Calendly Integration:** Automated scheduling

---

## ✅ Setup Complete!

Your TNT Tacky Lights Quote Tool is now fully operational!

**What you've built:**
- ✅ Professional booking form with live pricing
- ✅ Automated email confirmations
- ✅ Lead database with analytics
- ✅ Team notification system
- ✅ Mobile-responsive design
- ✅ Zero monthly costs (free tier)

**Questions?** Check the troubleshooting section or review the detailed guides in `/docs/`.

---

**Happy holidays and happy bookings! 🎄🚗✨**