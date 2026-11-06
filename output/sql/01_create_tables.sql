-- 01 표 세 개 만들기 (A-01 · R-10) — 실행: 2026-11-06, 프로젝트 adv5-receipt--240104 (마이그레이션 01_create_tables)
-- 다시 실행해도 오류 없음: 표 · 색인이 이미 있으면 건너뛴다(지우고 다시 만들지 않는다).
create table if not exists public.employee (
  emp_no text primary key,
  name   text not null,
  dept   text not null,
  title  text not null
);

create table if not exists public.receipt (
  id            bigint generated always as identity primary key,
  photo_path    text not null unique,
  emp_no        text not null references public.employee(emp_no),
  kind          text check (kind in ('식사','카페','택시')),
  used_at       timestamp,
  store_name    text,
  total         integer check (total >= 0),
  card_last4    text check (card_last4 ~ '^[0-9]{4}$'),
  purpose       text check (purpose in ('일반','회식','접대')),
  people        integer check (people > 0),
  guest_company text,
  memo          text,
  source        text not null check (source in ('AI','웹')),
  created_at    timestamptz not null default now(),
  check (kind is distinct from '택시' or (purpose is null and people is null and guest_company is null)),
  check (guest_company is null or purpose = '접대')
);
create index if not exists receipt_used_at_idx on public.receipt (used_at);

create table if not exists public.receipt_item (
  id          bigint generated always as identity primary key,
  receipt_id  bigint not null references public.receipt(id),
  item_name   text not null,
  qty         integer not null,
  unit_price  integer not null,
  amount      integer not null
);
create index if not exists receipt_item_receipt_id_idx on public.receipt_item (receipt_id);
