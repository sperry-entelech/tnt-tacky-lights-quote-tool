# TNT Limousine - Richmond Tacky Lights Tour Booking System

> **Production-ready booking tool with live pricing, address autocomplete, and automated workflows**

[![Deploy with Vercel](https://vercel.com/button)](https://vercel.com/new/clone?repository-url=https://github.com/sperry-entelech/tnt-tacky-lights-quote-tool)

---

## 🎄 Features

- **Live Pricing Calculator** - Instant quotes based on vehicle, date, and group size
- **Smart Vehicle Recommendations** - Auto-suggests best vehicle for passenger count
- **Address Autocomplete** - Powered by Radar API (100k free requests/month)
- **Lead Magnets** - Popups with free tacky lights guides and maps
- **Automated Workflows** - n8n integration for email confirmations and CRM
- **Supabase Database** - Secure lead storage with Row Level Security
- **Mobile-First Design** - Responsive TNT-branded interface (black & red)

---

## 🚀 Quick Start

**Prerequisites:** Accounts on [Supabase](https://supabase.com), [n8n Cloud](https://n8n.cloud), [Radar](https://radar.com), and [Vercel](https://vercel.com)

### 1. Clone Repository

```bash
git clone https://github.com/sperry-entelech/tnt-tacky-lights-quote-tool.git
cd tnt-tacky-lights-quote-tool
```

### 2. Set Up Supabase

1. Create project at https://supabase.com/dashboard
2. Go to SQL Editor → New Query
3. Copy & paste `docs/supabase-schema.sql`
4. Click "Run"

### 3. Configure n8n

Follow step-by-step guide: [`docs/N8N-SETUP-GUIDE.md`](docs/N8N-SETUP-GUIDE.md)

### 4. Deploy to Vercel

```bash
vercel
```

Add environment variables:
- `SUPABASE_URL`
- `SUPABASE_SERVICE_KEY`
- `N8N_WEBHOOK_URL`
- `RADAR_API_KEY`

---

## 📖 Documentation

- **[Complete Setup Guide](SETUP-GUIDE.md)** - Step-by-step deployment (45 minutes)
- **[n8n Workflow Setup](docs/N8N-SETUP-GUIDE.md)** - Email automation configuration
- **[Database Schema](docs/supabase-schema.sql)** - Supabase tables and RLS policies

---

## 📊 Pricing Table

Based on **2024 Tacky Lights Tour** rates (3-hour minimum):

| Vehicle | Capacity | Sun-Thu | Fri-Sat | Per Hour |
|---------|----------|---------|---------|----------|
| Lincoln Aviator | 3 | $300 | $375 | $100 |
| Ford Transit | 11 | $579 | $729 | $140 |
| Suburban | 6 | $465 | $589 | $155 |
| Stretch Limo | 8 | $499 | $649 | $158 |
| Sprinter Limo | 10 | $534 | $669 | $178 |
| Mini Bus Executive | 12 | $649 | $829 | $162 |
| Limo Bus | 18 | $749 | $939 | $240 |

---

## 🛠️ Tech Stack

- **Frontend:** HTML, CSS, Vanilla JavaScript
- **Backend:** Vercel Serverless Functions (Node.js)
- **Database:** Supabase (PostgreSQL)
- **Automation:** n8n Cloud
- **APIs:** Radar (address autocomplete)
- **Deployment:** Vercel (auto-deploy from GitHub)

---

## 📁 Project Structure

```
tnt-tacky-lights-quote-tool/
├── index.html              # Main booking form
├── success.html            # Confirmation page
├── package.json            # Dependencies
├── vercel.json             # Deployment config
├── .env.example            # Environment template
├── api/
│   └── submit-booking.js   # Form submission endpoint
├── assets/
│   ├── tnt-logo.png        # TNT logo
│   └── tacky-lights-data.json  # 61 locations
└── docs/
    ├── supabase-schema.sql     # Database setup
    ├── N8N-SETUP-GUIDE.md      # Workflow guide
    └── SETUP-GUIDE.md          # Main documentation
```

---

## 🔐 Environment Variables

Create `.env` file (see `.env.example`):

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_SERVICE_KEY=your-service-role-key
N8N_WEBHOOK_URL=https://your-n8n.app.n8n.cloud/webhook/tacky-lights-leads
RADAR_API_KEY=prj_live_pk_your-key
```

---

## 🆘 Troubleshooting

### Form not submitting?
- Check browser console (F12) for errors
- Verify all environment variables are set in Vercel
- Check API endpoint: `/api/submit-booking`

### No confirmation email?
- Verify n8n workflow is activated (ON)
- Check n8n execution log
- Look in spam folder

### Supabase errors?
- Check Row Level Security policies
- Verify service_role key (not anon key)
- Review Supabase logs

---

## 📞 Support

**TNT Limousine**
- Phone: (804) 972-4550
- Email: info@tntlimousine.com
- Website: https://tntlimousine.com

---

## 📝 License

Proprietary - TNT Limousine © 2024-2025

---

**Built with ❤️ for Richmond's holiday season**