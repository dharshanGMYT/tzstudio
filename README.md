# TZ Studio website

Official site for Thamizhans TZ Studios: short films, song remakes and movie remakes.
Static site (no build step). Database and logins by Supabase. Hosted on Vercel.

## Files
- `index.html`: the whole website
- `vercel.json`: Vercel settings (security headers)
- `supabase-setup.sql`: creates the database tables and admin rules

## 1. Supabase (database and logins)
1. Create a free project at supabase.com.
2. SQL Editor, New query: paste all of `supabase-setup.sql`, Run. This also makes `satheeshsai73@gmail.com` the owner.
3. Authentication, Sign In / Providers: keep **Confirm email ON**.
4. Project Settings, API: copy the **Project URL** and the **anon public key**.
5. Open `index.html`, find "DATABASE SETTINGS", and replace `PASTE_YOUR_SUPABASE_URL` and `PASTE_YOUR_ANON_PUBLIC_KEY`.

## 2. GitHub
Create a repository and upload all four files to the top level (not inside a folder).

## 3. Vercel
1. vercel.com, Add New, Project, import the GitHub repository.
2. Framework Preset: **Other**. Leave Build Command and Output Directory empty. Deploy.
3. Copy your site address (for example `https://tz-studio.vercel.app`).

## 4. Tell Supabase your site address
Authentication, URL Configuration:
- Site URL: your Vercel address
- Redirect URLs: add your Vercel address (and your own domain later)

Without this, the email confirmation link will not bring people back to the site.

## 5. First login
1. Open the site, click **Sign in**, then **Create one**, and register with `satheeshsai73@gmail.com`.
2. Confirm the email. You land on the site signed in as the owner and the **Admin** tab appears.
3. Add videos and series in the Admin panel. Use the **Admins** tab to add other admins by email (they must create and confirm an account first).

## Updating the site
Edit `index.html` on GitHub. Vercel redeploys automatically.
Videos, series, branding and views are stored in Supabase, so they are not lost when you redeploy.
