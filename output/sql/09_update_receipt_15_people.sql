-- 09 말로 고치기: receipt_15.jpg 인원 3 → 4, 이 영수증 하나만 (A-07 · T-12) — 실행: 2026-11-06 · 결과: 1건(id 3, 온기 쌀국수, 인원 4)
update public.receipt
   set people = 4
 where photo_path = 'receipt_15.jpg'
   and people = 3
returning id, photo_path, store_name, people;
