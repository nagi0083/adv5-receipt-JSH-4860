-- 10 고친 뒤 식사 1인당 다시 계산 + 공개용 키(anon) 권한 목록 (A-10 · T-12, T-13) — 실행: 2026-11-06 · 읽기만
-- 결과: 식사 1인당 1,623,000원 ÷ 48명 = 33,813원
--       표는 권한(grant, 칸 단위 포함)과 정책이 둘 다 있어야 "할 수 있다". 저장소는 정책 기준.
select 'meal' as k, sum(total)::text || '원 ÷ ' || sum(people) || '명 = ' || round(sum(total)::numeric / nullif(sum(people), 0)) || '원' as v,
       null::text as a, null::text as b, null::text as c
from public.receipt where to_char(used_at, 'YYYY-MM') = '2026-10' and kind = '식사' and people > 0
union all
select 'table:' || t.tbl, p.priv,
       case when p.priv = 'DELETE' then has_table_privilege('anon', ('public.' || t.tbl)::regclass, 'DELETE')
            else has_any_column_privilege('anon', ('public.' || t.tbl)::regclass, p.priv) end::text,
       (select string_agg(policyname, ',') from pg_policies
         where schemaname = 'public' and tablename = t.tbl and cmd in (p.priv, 'ALL') and roles && array['anon', 'public']::name[]),
       null
from (values ('employee'), ('receipt'), ('receipt_item')) t(tbl)
cross join (values ('SELECT'), ('INSERT'), ('UPDATE'), ('DELETE')) p(priv)
union all
select 'storage:receipts', p.priv,
       has_table_privilege('anon', 'storage.objects', p.priv)::text,
       (select string_agg(policyname, ',') from pg_policies
         where schemaname = 'storage' and tablename = 'objects' and cmd in (p.priv, 'ALL') and roles && array['anon', 'public']::name[]
           and (coalesce(qual, '') || coalesce(with_check, '')) like '%receipts%'),
       (select string_agg(policyname, ',') from pg_policies
         where schemaname = 'storage' and tablename = 'objects' and cmd in (p.priv, 'ALL') and roles && array['anon', 'public']::name[])
from (values ('SELECT'), ('INSERT'), ('UPDATE'), ('DELETE')) p(priv)
union all
select 'rls:' || relname, relrowsecurity::text, null, null, null
from pg_class where oid in ('public.employee'::regclass, 'public.receipt'::regclass, 'public.receipt_item'::regclass, 'storage.objects'::regclass);
