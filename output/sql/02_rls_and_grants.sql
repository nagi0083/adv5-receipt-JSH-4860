-- 02 권한 규칙(RLS) · 권한 주기 (A-01 · R-11) — 실행: 2026-11-06 (마이그레이션 02_rls_and_grants)
-- 다시 실행해도 오류 없음: RLS 켜기 · grant는 여러 번 해도 같고, 정책은 이미 있으면 건너뛴다.
alter table public.employee     enable row level security;
alter table public.receipt      enable row level security;
alter table public.receipt_item enable row level security;

grant usage on schema public to anon;
grant select on public.employee, public.receipt, public.receipt_item to anon;
grant insert (photo_path, emp_no, kind, used_at, store_name, total,
              purpose, people, guest_company, memo, source) on public.receipt to anon;

do $$
begin
  if not exists (select 1 from pg_policies where schemaname = 'public' and tablename = 'employee' and policyname = 'employee_read') then
    create policy employee_read on public.employee for select to anon using (true);
  end if;
  if not exists (select 1 from pg_policies where schemaname = 'public' and tablename = 'receipt' and policyname = 'receipt_read') then
    create policy receipt_read on public.receipt for select to anon using (true);
  end if;
  if not exists (select 1 from pg_policies where schemaname = 'public' and tablename = 'receipt_item' and policyname = 'receipt_item_read') then
    create policy receipt_item_read on public.receipt_item for select to anon using (true);
  end if;
  if not exists (select 1 from pg_policies where schemaname = 'public' and tablename = 'receipt' and policyname = 'receipt_insert_web') then
    create policy receipt_insert_web on public.receipt for insert to anon
      with check (source = '웹'
              and photo_path like 'web\_%'
              and kind is not null and used_at is not null
              and store_name is not null and total is not null);
  end if;
end $$;
