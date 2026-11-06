-- 08 말로 묻기: 2026년 10월 집계 (A-06 · T-11) — 실행: 2026-11-06 · 읽기만
-- 결과(고치기 전): 전체 20건 1,707,200원 · 일반 10건 289,500 · 회식 3건 659,000 · 접대 4건 716,000 · 목적 없음 3건 42,700
--                  식사 1인당 1,623,000원 ÷ 47명 = 34,532원 · 웹 등록분 0건
with m as (
  select * from public.receipt where to_char(used_at, 'YYYY-MM') = '2026-10'
)
select 0 as ord, 'AI 영수증 전체' as item, (select count(*) from public.receipt where source='AI')::text as cnt,
       (select count(*) from public.receipt_item i join public.receipt r on r.id = i.receipt_id where r.source='AI')::text || '줄(품목)' as amount
union all select 1, '10월 전체', count(*)::text, sum(total)::text from m
union all select 2, '10월 등록 방식 ' || source, count(*)::text, sum(total)::text from m group by source
union all select 3, '목적 ' || coalesce(purpose, '목적 없음'), count(*)::text, sum(total)::text from m group by purpose
union all select 4, '식사 1인당', sum(people)::text || '명', sum(total)::text || '원 ÷ ' || sum(people) || '명 = ' || round(sum(total)::numeric / nullif(sum(people), 0)) || '원'
  from m where kind = '식사' and people > 0
order by 1, 2;
