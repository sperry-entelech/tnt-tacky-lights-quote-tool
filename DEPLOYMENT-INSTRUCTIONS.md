# 🚀 TNT Tacky Lights - Final Deployment Instructions

> **Your credentials are configured. Follow these exact steps to go live.**

---

## ✅ What's Already Done

✅ Code repository created and pushed to GitHub
✅ Database schema ready
✅ n8n workflow template created
✅ Vercel configuration ready

---

## 📋 What You Need to Do (30 minutes)

### Step 1: Set Up Radar API (5 minutes)

#### Get Your Free API Key:
1. Go to: https://radar.com/
2. Click **"Start for Free"**
3. Sign up with email: `sperryinquiries@gmail.com` (or any email)
4. Verify email
5. Create project named: **"TNT Limousine"**
6. Go to **Settings** → **API Keys**
7. Copy your **Publishable Key** (starts with `prj_live_pk_`)

**Save this key** - you'll add it to Vercel in Step 3.

---

### Step 2: Set Up Supabase Database (5 minutes)

#### Run the Database Schema:

1. Go to your Supabase project:
   https://supabase.com/dashboard/project/jyjwnourilmeoenmerhw

2. Click **SQL Editor** (left sidebar)

3. Click **"New Query"**

4. Go to your local folder:
   `C:\Users\spder\tnt-tacky-lights-quote-tool\docs\supabase-schema.sql`

5. Open the file, **Copy ALL the SQL**

6. Paste into Supabase SQL Editor

7. Click **"Run"** button (bottom right)

8. You should see: ✅ **Success. No rows returned**

**What this creates:**
- `tacky_lights_leads` table (stores bookings)
- `quick_quotes` table
- Security policies
- Analytics views

**Verify it worked:**
- Click **Table Editor** → You should see `tacky_lights_leads` table

---

### Step 3: Deploy to Vercel (10 minutes)

#### 3.1 Deploy the Project:

1. Go to: https://vercel.com/new
2. Click **"Import Git Repository"**
3. Find: `sperry-entelech/tnt-tacky-lights-quote-tool`
4. Click **"Import"**
5. **Project Name:** `tnt-tacky-lights-quote-tool`
6. **Framework:** Leave as "Other"
7. Click **"Deploy"**
8. Wait 2-3 minutes

#### 3.2 Add Environment Variables:

After deployment completes:

1. Go to your project settings
2. Click **Settings** → **Environment Variables**
3. Add these **EXACT** variables (one by one):

| Variable Name | Value |
|---------------|-------|
| `SUPABASE_URL` | `https://jyjwnourilmeoenmerhw.supabase.co` |
| `SUPABASE_SERVICE_KEY` | `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp5andub3VyaWxtZW9lbm1lcmh3Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2MTI0MzYzMSwiZXhwIjoyMDc2ODE5NjMxfQ.vONsrZXBwPlBJh5w9UbXCGh-0nZ_tjxBrsnWbwk-v0A` |
| `N8N_WEBHOOK_URL` | (You'll get this in Step 4) |
| `RADAR_API_KEY` | (Paste the key from Step 1) |

⚠️ **Important:** For each variable, make sure to check:
- ☑ Production
- ☑ Preview
- ☑ Development

4. Click **"Save"** after adding all variables

#### 3.3 Redeploy:

1. Go to **Deployments** tab
2. Click **"..."** on the latest deployment
3. Click **"Redeploy"**
4. Wait 1-2 minutes

---

### Step 4: Configure n8n Workflow (10 minutes)

#### 4.1 Log into n8n:

1. Go to: https://app.n8n.cloud/
2. Email: `sperryinquiries@gmail.com`
3. Password: `$Pdery17`

#### 4.2 Create New Workflow:

1. Click **"+ New Workflow"** (top right)
2. Name it: **"TNT Tacky Lights - Lead Capture"**
3. Click **"Save"**

#### 4.3 Add Webhook Node:

1. Click the **"+"** button
2. Search for **"Webhook"**
3. Click on it
4. Configure:
   - **HTTP Method:** `POST`
   - **Path:** `tacky-lights-leads`
   - **Authentication:** `None`

5. **IMPORTANT:** Click **"Listen for Test Event"** button

6. **Copy the webhook URL** - it looks like:
   ```
   https://sperryin-tuyccbzr.app.n8n.cloud/webhook/tacky-lights-leads
   ```

7. **GO BACK TO VERCEL** and add this as `N8N_WEBHOOK_URL` environment variable

8. **Redeploy Vercel again** (Deployments → "..." → Redeploy)

#### 4.4 Add Supabase Node:

1. Click **"+"** after Webhook node
2. Search for **"Supabase"**
3. Click on it
4. Click **"Create New Credential"**
5. Fill in:
   - **Host:** `https://jyjwnourilmeoenmerhw.supabase.co`
   - **Service Role Key:** `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp5andub3VyaWxtZW9lbm1lcmh3Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2MTI0MzYzMSwiZXhwIjoyMDc2ODE5NjMxfQ.vONsrZXBwPlBJh5w9UbXCGh-0nZ_tjxBrsnWbwk-v0A`

6. Click **"Save"**

7. Configure the node:
   - **Operation:** `Insert`
   - **Table:** `tacky_lights_leads`

8. **Map the fields** (click "Add Field" for each):

```
booking_ref → {{ $json.bookingRef }}
first_name → {{ $json.customer.firstName }}
last_name → {{ $json.customer.lastName }}
email → {{ $json.customer.email }}
phone → {{ $json.customer.phone }}
pickup_address → {{ $json.tourDetails.pickupAddress }}
tour_date → {{ $json.tourDetails.date }}
tour_time → {{ $json.tourDetails.time }}
group_size → {{ $json.tourDetails.groupSize }}
vehicle_type → {{ $json.tourDetails.vehicleType }}
vehicle_key → {{ $json.tourDetails.vehicleKey }}
price_quoted → {{ $json.pricing.quoted }}
special_requests → {{ $json.metadata.specialRequests }}
hear_about_us → {{ $json.metadata.hearAboutUs }}
lead_source → {{ $json.metadata.leadSource }}
status → new
```

#### 4.5 Add Email Node (Customer):

1. Click **"+"** after Supabase node
2. Search for **"Gmail"** (since you're using sperryinquiries@gmail.com)
3. Click on it
4. Click **"Create New Credential"**
5. **Connect your Google account** (sperryinquiries@gmail.com)
6. Allow permissions

7. Configure:
   - **Resource:** `Message`
   - **Operation:** `Send`
   - **To:** `{{ $json.customer.email }}`
   - **Subject:** `Your TNT Tacky Lights Tour Quote - {{ $json.bookingRef }}`
   - **Email Type:** `HTML`
   - **Body:**

Open `docs/N8N-SETUP-GUIDE.md` and copy the "Customer Email Template" HTML (around line 135)

#### 4.6 Add Email Node (Team):

1. Click **"+"** after customer email
2. Add another **Gmail** node
3. Configure:
   - **To:** `sperryinquiries@gmail.com` (or your dispatch email)
   - **Subject:** `🚨 NEW Tacky Lights Lead - {{ $json.bookingRef }}`
   - **Email Type:** `HTML`
   - **Body:**

Copy the "Team Notification Template" from `docs/N8N-SETUP-GUIDE.md` (around line 185)

#### 4.7 Activate Workflow:

1. Click **"Save"** (top right)
2. Toggle workflow **ON** (switch at top)

---

### Step 5: Test Everything (5 minutes)

#### Run a Test Booking:

1. Go to your live site:
   `https://tnt-tacky-lights-quote-tool.vercel.app`

2. Fill out the form with test data:
   - **Name:** Test User
   - **Email:** `sperryinquiries@gmail.com` (so you get the email)
   - **Phone:** (804) 555-1234
   - **Date:** Tomorrow
   - **Group Size:** 4 passengers
   - **Vehicle:** Suburban

3. Submit the form

#### Verify Success:

✅ **Success Page** - You should see booking reference (e.g., `TLT-20251223-1234`)

✅ **Customer Email** - Check Gmail inbox for confirmation

✅ **Team Email** - Check Gmail for team notification

✅ **Supabase** - Go to Supabase → Table Editor → `tacky_lights_leads` → See new row

✅ **n8n** - Go to n8n → Workflow → Executions → See successful run

---

## 🎉 You're Live!

If all 5 checkmarks are green ✅, your system is fully operational!

### Your Live URLs:

- **Booking Form:** https://tnt-tacky-lights-quote-tool.vercel.app
- **Supabase Dashboard:** https://supabase.com/dashboard/project/jyjwnourilmeoenmerhw
- **n8n Dashboard:** https://app.n8n.cloud/

---

## 🔧 Optional: Add Custom Domain

Want to use `tacky-lights.tntlimousine.com` instead?

1. In Vercel, go to **Settings** → **Domains**
2. Add: `tacky-lights.tntlimousine.com`
3. Follow DNS instructions (add CNAME record)

---

## 📊 How to View Leads

### In Supabase:
1. Go to **Table Editor**
2. Click `tacky_lights_leads`
3. See all bookings in real-time

### Filter by Status:
- `status = 'new'` → Uncontacted leads
- Sort by `created_at` → Most recent first

---

## 🆘 Troubleshooting

### Form not submitting?
- Check browser console (F12 → Console tab)
- Verify all environment variables are set in Vercel
- Make sure you redeployed after adding N8N_WEBHOOK_URL

### No emails?
- Check spam folder
- Verify Gmail credentials in n8n
- Check n8n execution log for errors
- Make sure workflow is ON (green toggle)

### Supabase errors?
- Verify schema was run successfully
- Check that service_role key is correct
- View Supabase Logs for errors

---

## 📞 Questions?

If you get stuck:
1. Check the execution history in n8n (shows exactly what failed)
2. View Supabase logs (Settings → Logs)
3. Check Vercel function logs (Functions → Logs)

---

**Ready to deploy? Follow Step 1 above! 🚀**