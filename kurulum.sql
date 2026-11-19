-- Anı Panosu: Supabase SQL Editor'de bir kez çalıştırılır.
-- En alttaki iki e-postayı panoya girecek iki kişinin adresiyle değiştirin.
create table if not exists public.izinli (email text primary key);
create table if not exists public.kayitlar (id text primary key, data jsonb not null, guncel timestamptz not null default now());
create table if not exists public.sorular (id text primary key, data jsonb not null, guncel timestamptz not null default now());
create table if not exists public.uyeler (id uuid primary key references auth.users(id) on delete cascade, ad text not null);

alter table public.izinli enable row level security;
alter table public.kayitlar enable row level security;
alter table public.sorular enable row level security;
alter table public.uyeler enable row level security;

grant select, insert, update, delete on public.kayitlar, public.sorular, public.uyeler to authenticated;

create or replace function public.pano_uye() returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.izinli where lower(email) = lower(auth.jwt() ->> 'email'));
$$;
grant execute on function public.pano_uye() to authenticated;

create policy "uye kayitlar" on public.kayitlar for all to authenticated using (public.pano_uye()) with check (public.pano_uye());
create policy "uye sorular" on public.sorular for all to authenticated using (public.pano_uye()) with check (public.pano_uye());
create policy "uye okur" on public.uyeler for select to authenticated using (public.pano_uye());
create policy "uye adini yazar" on public.uyeler for insert to authenticated with check (public.pano_uye() and id = auth.uid());
create policy "uye adini degistirir" on public.uyeler for update to authenticated using (id = auth.uid()) with check (public.pano_uye() and id = auth.uid());

insert into storage.buckets (id, name, public) values ('foto', 'foto', false) on conflict (id) do nothing;
create policy "uye foto okur" on storage.objects for select to authenticated using (bucket_id = 'foto' and public.pano_uye());
create policy "uye foto yukler" on storage.objects for insert to authenticated with check (bucket_id = 'foto' and public.pano_uye());
create policy "uye foto siler" on storage.objects for delete to authenticated using (bucket_id = 'foto' and public.pano_uye());

alter publication supabase_realtime add table public.kayitlar, public.sorular;

insert into public.izinli (email) values ('BIRINCI@EPOSTA.com'), ('IKINCI@EPOSTA.com');
