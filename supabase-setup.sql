-- TZ Studio database setup (safe to run again). Supabase: SQL Editor -> New query -> paste all -> Run.

-- Website content (videos, series, branding), one row
create table if not exists site_data (
  id int primary key,
  data jsonb not null,
  updated_at timestamptz default now()
);

-- Audience views shared by all visitors
create table if not exists views (
  ep text primary key,
  n bigint not null default 0
);

-- Admin list. The owner is added below.
create table if not exists admins (
  email text primary key,
  role text not null default 'admin' check (role in ('owner','admin'))
);

create or replace function is_admin() returns boolean
language sql security definer stable set search_path = public as $$
  select exists (select 1 from admins where lower(email) = lower(coalesce(auth.jwt()->>'email','')))
$$;

create or replace function is_owner() returns boolean
language sql security definer stable set search_path = public as $$
  select exists (select 1 from admins where role = 'owner' and lower(email) = lower(coalesce(auth.jwt()->>'email','')))
$$;

create or replace function inc_view(p_ep text) returns void
language sql security definer set search_path = public as $$
  insert into views(ep, n) values (p_ep, 1)
  on conflict (ep) do update set n = views.n + 1
$$;

grant execute on function is_admin(), is_owner() to anon, authenticated;
grant execute on function inc_view(text) to anon, authenticated;

alter table site_data enable row level security;
alter table views enable row level security;
alter table admins enable row level security;

drop policy if exists "anyone can read site" on site_data;
drop policy if exists "admin can insert site" on site_data;
drop policy if exists "admin can update site" on site_data;
drop policy if exists "admins insert site" on site_data;
drop policy if exists "admins update site" on site_data;
create policy "anyone can read site" on site_data for select using (true);
create policy "admins insert site" on site_data for insert to authenticated with check (is_admin());
create policy "admins update site" on site_data for update to authenticated using (is_admin()) with check (is_admin());

drop policy if exists "anyone can read views" on views;
create policy "anyone can read views" on views for select using (true);

drop policy if exists "read own or all if admin" on admins;
drop policy if exists "owner adds admins" on admins;
drop policy if exists "owner removes admins" on admins;
create policy "read own or all if admin" on admins for select to authenticated
  using (lower(email) = lower(coalesce(auth.jwt()->>'email','')) or is_admin());
create policy "owner adds admins" on admins for insert to authenticated
  with check (is_owner() and role = 'admin');
create policy "owner removes admins" on admins for delete to authenticated
  using (is_owner() and role = 'admin');

-- Main owner
insert into admins (email, role) values ('satheeshsai73@gmail.com', 'owner')
on conflict (email) do update set role = 'owner';
