-- 07 두 번 넣지 않기 시험: 05를 그대로 다시 실행 (T-09) — 실행: 2026-11-06 · 결과: 새 영수증 0 · 새 품목 0
-- 05와 같은 내용에, 새로 들어간 수를 세는 마지막 문장만 덧붙였다.
-- 원본: output\읽은결과.xlsx (정산 담당 확인) · 등록 방식 AI
-- 이미 같은 사진 파일 이름이 있으면 그 영수증과 품목은 넣지 않는다(R-20).
with r(photo_path, emp_no, kind, used_at, store_name, total, card_last4, purpose, people, guest_company, memo) as (values
  ('receipt_01.jpg', 'E2101', '식사', timestamp '2026-10-01 12:12', '한결식당', 28000, '4821', '일반', 2, null, '외근 중 점심 — 이도현 대리와'),
  ('receipt_02.jpg', 'E2102', '식사', timestamp '2026-10-02 12:35', '청솔칼국수', 38000, '7350', '일반', 3, null, '샘플실 방문 후 점심'),
  ('receipt_03.jpg', 'E2103', '식사', timestamp '2026-10-06 12:20', '돈마루 돈까스', 34500, '1694', '일반', 3, null, '물류센터 출장 점심'),
  ('receipt_04.jpg', 'E2101', '식사', timestamp '2026-10-07 19:05', '숯불명가', 170000, '4821', '회식', 6, null, '영업1팀 3분기 마감 회식'),
  ('receipt_05.jpg', 'E2201', '식사', timestamp '2026-10-08 12:40', '남도한상', 48000, '2286', '일반', 4, null, '전시회 준비 회의 점심'),
  ('receipt_06.jpg', 'E2102', '카페', timestamp '2026-10-12 15:10', '카페 온새', 12500, '7350', '일반', 2, null, '원단 업체 미팅 전 회의'),
  ('receipt_07.jpg', 'E2101', '택시', timestamp '2026-10-12 18:55', '가람운수', 14300, '4821', null, null, null, 'ABC Sports 저녁 미팅 장소로 이동'),
  ('receipt_08.jpg', 'E2101', '식사', timestamp '2026-10-12 19:20', '수라 한정식', 190000, '4821', '접대', 3, 'ABC Sports', '시즌 오더 미팅 저녁'),
  ('receipt_09.jpg', 'E2202', '식사', timestamp '2026-10-13 12:15', '소담 비빔밥', 38000, '5047', '일반', 2, null, '고객사 방문 후 점심'),
  ('receipt_10.jpg', 'E2201', '카페', timestamp '2026-10-14 14:30', '브루잉랩', 21000, '2286', '접대', 4, 'DEF Golf', '샘플 협의 미팅'),
  ('receipt_11.jpg', 'E2201', '식사', timestamp '2026-10-14 18:40', '스시 하루', 325000, '2286', '접대', 4, 'DEF Golf', '샘플 협의 후 저녁'),
  ('receipt_12.jpg', 'E2103', '택시', timestamp '2026-10-15 09:40', '한빛교통', 9800, '1694', null, null, null, '급한 샘플 전달 — 거래처 방문'),
  ('receipt_13.jpg', 'E2203', '식사', timestamp '2026-10-15 12:30', '마포 순댓국', 20000, '9132', '일반', 2, null, '외근 중 점심'),
  ('receipt_14.jpg', 'E2201', '식사', timestamp '2026-10-16 18:50', '바다향 횟집', 201000, '2286', '회식', 5, null, '영업2팀 회식'),
  ('receipt_15.jpg', 'E2301', '식사', timestamp '2026-10-19 12:25', '온기 쌀국수', 44000, '3378', '일반', 3, null, '주간 업무 회의 후 점심'),
  ('receipt_16.jpg', 'E2202', '식사', timestamp '2026-10-20 19:00', '그릴 앤 테이블', 180000, '5047', '접대', 3, 'GHI Outdoor', '신규 라인 소개 저녁'),
  ('receipt_17.jpg', 'E2202', '택시', timestamp '2026-10-20 21:45', '새벽운수', 18600, '5047', null, null, null, 'GHI Outdoor 바이어 호텔까지 배웅'),
  ('receipt_18.jpg', 'E2302', '식사', timestamp '2026-10-21 12:10', '하루 김밥', 18500, '6605', '일반', 2, null, '외근 중 점심'),
  ('receipt_19.jpg', 'E2203', '카페', timestamp '2026-10-22 16:05', '커피 한모금', 8000, '9132', '일반', 2, null, '거래처 미팅 전 대기'),
  ('receipt_20.jpg', 'E2301', '식사', timestamp '2026-10-23 19:10', '화로정', 288000, '3378', '회식', 5, null, '영업지원팀 회식')
), ins as (
  insert into public.receipt (photo_path, emp_no, kind, used_at, store_name, total, card_last4, purpose, people, guest_company, memo, source)
  select photo_path, emp_no, kind, used_at, store_name, total, card_last4, purpose, people, guest_company, memo, 'AI' from r
  where not exists (select 1 from public.receipt x where x.photo_path = r.photo_path)
  returning id, photo_path
), it(photo_path, item_name, qty, unit_price, amount) as (values
  ('receipt_01.jpg', '김치찌개', 2, 9500, 19000),
  ('receipt_01.jpg', '계란말이', 1, 9000, 9000),
  ('receipt_02.jpg', '칼국수', 3, 10000, 30000),
  ('receipt_02.jpg', '왕만두', 1, 8000, 8000),
  ('receipt_03.jpg', '등심돈까스', 2, 11000, 22000),
  ('receipt_03.jpg', '치즈돈까스', 1, 12500, 12500),
  ('receipt_04.jpg', '돼지갈비', 8, 17000, 136000),
  ('receipt_04.jpg', '공기밥', 6, 1000, 6000),
  ('receipt_04.jpg', '된장찌개', 2, 4000, 8000),
  ('receipt_04.jpg', '소주', 4, 5000, 20000),
  ('receipt_05.jpg', '제육정식', 4, 12000, 48000),
  ('receipt_06.jpg', '아메리카노', 2, 4500, 9000),
  ('receipt_06.jpg', '마들렌', 1, 3500, 3500),
  ('receipt_07.jpg', '택시 운임', 1, 14300, 14300),
  ('receipt_08.jpg', '한정식 코스', 3, 55000, 165000),
  ('receipt_08.jpg', '복분자주', 1, 25000, 25000),
  ('receipt_09.jpg', '돌솥비빔밥', 2, 11000, 22000),
  ('receipt_09.jpg', '해물파전', 1, 16000, 16000),
  ('receipt_10.jpg', '카페라떼', 2, 5500, 11000),
  ('receipt_10.jpg', '아메리카노', 2, 5000, 10000),
  ('receipt_11.jpg', '오마카세', 4, 70000, 280000),
  ('receipt_11.jpg', '사케', 1, 45000, 45000),
  ('receipt_12.jpg', '택시 운임', 1, 9800, 9800),
  ('receipt_13.jpg', '순댓국', 2, 10000, 20000),
  ('receipt_14.jpg', '모둠회(대)', 2, 75000, 150000),
  ('receipt_14.jpg', '매운탕', 1, 20000, 20000),
  ('receipt_14.jpg', '소주', 5, 5000, 25000),
  ('receipt_14.jpg', '음료', 2, 3000, 6000),
  ('receipt_15.jpg', '쌀국수', 3, 12000, 36000),
  ('receipt_15.jpg', '짜조', 1, 8000, 8000),
  ('receipt_16.jpg', '안심 스테이크', 2, 48000, 96000),
  ('receipt_16.jpg', '크림 파스타', 1, 26000, 26000),
  ('receipt_16.jpg', '하우스 와인', 1, 58000, 58000),
  ('receipt_17.jpg', '택시 운임', 1, 18600, 18600),
  ('receipt_18.jpg', '참치김밥', 2, 5500, 11000),
  ('receipt_18.jpg', '라볶이', 1, 7500, 7500),
  ('receipt_19.jpg', '아이스 아메리카노', 2, 4000, 8000),
  ('receipt_20.jpg', '한우 등심', 6, 38000, 228000),
  ('receipt_20.jpg', '물냉면', 4, 9000, 36000),
  ('receipt_20.jpg', '맥주', 4, 6000, 24000)
-- 원본: output\읽은결과.xlsx (정산 담당 확인) · 등록 방식 AI
-- 이미 같은 사진 파일 이름이 있으면 그 영수증과 품목은 넣지 않는다(R-20).
with r(photo_path, emp_no, kind, used_at, store_name, total, card_last4, purpose, people, guest_company, memo) as (values
  ('receipt_01.jpg', 'E2101', '식사', timestamp '2026-10-01 12:12', '한결식당', 28000, '4821', '일반', 2, null, '외근 중 점심 — 이도현 대리와'),
  ('receipt_02.jpg', 'E2102', '식사', timestamp '2026-10-02 12:35', '청솔칼국수', 38000, '7350', '일반', 3, null, '샘플실 방문 후 점심'),
  ('receipt_03.jpg', 'E2103', '식사', timestamp '2026-10-06 12:20', '돈마루 돈까스', 34500, '1694', '일반', 3, null, '물류센터 출장 점심'),
  ('receipt_04.jpg', 'E2101', '식사', timestamp '2026-10-07 19:05', '숯불명가', 170000, '4821', '회식', 6, null, '영업1팀 3분기 마감 회식'),
  ('receipt_05.jpg', 'E2201', '식사', timestamp '2026-10-08 12:40', '남도한상', 48000, '2286', '일반', 4, null, '전시회 준비 회의 점심'),
  ('receipt_06.jpg', 'E2102', '카페', timestamp '2026-10-12 15:10', '카페 온새', 12500, '7350', '일반', 2, null, '원단 업체 미팅 전 회의'),
  ('receipt_07.jpg', 'E2101', '택시', timestamp '2026-10-12 18:55', '가람운수', 14300, '4821', null, null, null, 'ABC Sports 저녁 미팅 장소로 이동'),
  ('receipt_08.jpg', 'E2101', '식사', timestamp '2026-10-12 19:20', '수라 한정식', 190000, '4821', '접대', 3, 'ABC Sports', '시즌 오더 미팅 저녁'),
  ('receipt_09.jpg', 'E2202', '식사', timestamp '2026-10-13 12:15', '소담 비빔밥', 38000, '5047', '일반', 2, null, '고객사 방문 후 점심'),
  ('receipt_10.jpg', 'E2201', '카페', timestamp '2026-10-14 14:30', '브루잉랩', 21000, '2286', '접대', 4, 'DEF Golf', '샘플 협의 미팅'),
  ('receipt_11.jpg', 'E2201', '식사', timestamp '2026-10-14 18:40', '스시 하루', 325000, '2286', '접대', 4, 'DEF Golf', '샘플 협의 후 저녁'),
  ('receipt_12.jpg', 'E2103', '택시', timestamp '2026-10-15 09:40', '한빛교통', 9800, '1694', null, null, null, '급한 샘플 전달 — 거래처 방문'),
  ('receipt_13.jpg', 'E2203', '식사', timestamp '2026-10-15 12:30', '마포 순댓국', 20000, '9132', '일반', 2, null, '외근 중 점심'),
  ('receipt_14.jpg', 'E2201', '식사', timestamp '2026-10-16 18:50', '바다향 횟집', 201000, '2286', '회식', 5, null, '영업2팀 회식'),
  ('receipt_15.jpg', 'E2301', '식사', timestamp '2026-10-19 12:25', '온기 쌀국수', 44000, '3378', '일반', 3, null, '주간 업무 회의 후 점심'),
  ('receipt_16.jpg', 'E2202', '식사', timestamp '2026-10-20 19:00', '그릴 앤 테이블', 180000, '5047', '접대', 3, 'GHI Outdoor', '신규 라인 소개 저녁'),
  ('receipt_17.jpg', 'E2202', '택시', timestamp '2026-10-20 21:45', '새벽운수', 18600, '5047', null, null, null, 'GHI Outdoor 바이어 호텔까지 배웅'),
  ('receipt_18.jpg', 'E2302', '식사', timestamp '2026-10-21 12:10', '하루 김밥', 18500, '6605', '일반', 2, null, '외근 중 점심'),
  ('receipt_19.jpg', 'E2203', '카페', timestamp '2026-10-22 16:05', '커피 한모금', 8000, '9132', '일반', 2, null, '거래처 미팅 전 대기'),
  ('receipt_20.jpg', 'E2301', '식사', timestamp '2026-10-23 19:10', '화로정', 288000, '3378', '회식', 5, null, '영업지원팀 회식')
), ins as (
  insert into public.receipt (photo_path, emp_no, kind, used_at, store_name, total, card_last4, purpose, people, guest_company, memo, source)
  select photo_path, emp_no, kind, used_at, store_name, total, card_last4, purpose, people, guest_company, memo, 'AI' from r
  where not exists (select 1 from public.receipt x where x.photo_path = r.photo_path)
  returning id, photo_path
), it(photo_path, item_name, qty, unit_price, amount) as (values
  ('receipt_01.jpg', '김치찌개', 2, 9500, 19000),
  ('receipt_01.jpg', '계란말이', 1, 9000, 9000),
  ('receipt_02.jpg', '칼국수', 3, 10000, 30000),
  ('receipt_02.jpg', '왕만두', 1, 8000, 8000),
  ('receipt_03.jpg', '등심돈까스', 2, 11000, 22000),
  ('receipt_03.jpg', '치즈돈까스', 1, 12500, 12500),
  ('receipt_04.jpg', '돼지갈비', 8, 17000, 136000),
  ('receipt_04.jpg', '공기밥', 6, 1000, 6000),
  ('receipt_04.jpg', '된장찌개', 2, 4000, 8000),
  ('receipt_04.jpg', '소주', 4, 5000, 20000),
  ('receipt_05.jpg', '제육정식', 4, 12000, 48000),
  ('receipt_06.jpg', '아메리카노', 2, 4500, 9000),
  ('receipt_06.jpg', '마들렌', 1, 3500, 3500),
  ('receipt_07.jpg', '택시 운임', 1, 14300, 14300),
  ('receipt_08.jpg', '한정식 코스', 3, 55000, 165000),
  ('receipt_08.jpg', '복분자주', 1, 25000, 25000),
  ('receipt_09.jpg', '돌솥비빔밥', 2, 11000, 22000),
  ('receipt_09.jpg', '해물파전', 1, 16000, 16000),
  ('receipt_10.jpg', '카페라떼', 2, 5500, 11000),
  ('receipt_10.jpg', '아메리카노', 2, 5000, 10000),
  ('receipt_11.jpg', '오마카세', 4, 70000, 280000),
  ('receipt_11.jpg', '사케', 1, 45000, 45000),
  ('receipt_12.jpg', '택시 운임', 1, 9800, 9800),
  ('receipt_13.jpg', '순댓국', 2, 10000, 20000),
  ('receipt_14.jpg', '모둠회(대)', 2, 75000, 150000),
  ('receipt_14.jpg', '매운탕', 1, 20000, 20000),
  ('receipt_14.jpg', '소주', 5, 5000, 25000),
  ('receipt_14.jpg', '음료', 2, 3000, 6000),
  ('receipt_15.jpg', '쌀국수', 3, 12000, 36000),
  ('receipt_15.jpg', '짜조', 1, 8000, 8000),
  ('receipt_16.jpg', '안심 스테이크', 2, 48000, 96000),
  ('receipt_16.jpg', '크림 파스타', 1, 26000, 26000),
  ('receipt_16.jpg', '하우스 와인', 1, 58000, 58000),
  ('receipt_17.jpg', '택시 운임', 1, 18600, 18600),
  ('receipt_18.jpg', '참치김밥', 2, 5500, 11000),
  ('receipt_18.jpg', '라볶이', 1, 7500, 7500),
  ('receipt_19.jpg', '아이스 아메리카노', 2, 4000, 8000),
  ('receipt_20.jpg', '한우 등심', 6, 38000, 228000),
  ('receipt_20.jpg', '물냉면', 4, 9000, 36000),
  ('receipt_20.jpg', '맥주', 4, 6000, 24000)
), ins_items as (
  insert into public.receipt_item (receipt_id, item_name, qty, unit_price, amount)
  select ins.id, it.item_name, it.qty, it.unit_price, it.amount
  from it join ins on ins.photo_path = it.photo_path
  returning id
)
select (select count(*) from ins) as new_receipts, (select count(*) from ins_items) as new_items;
