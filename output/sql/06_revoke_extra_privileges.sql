-- 06 공개용 키 · 로그인 역할에 자동으로 붙은 필요 없는 권한 거두기 (R-11 · T-13) — 실행: 2026-11-06 (마이그레이션 06_revoke_extra_privileges)
-- 표를 비우는 명령이 아니라, 비우기(truncate) · 트리거 · 참조 권한을 거두는 명령이다. 다시 실행해도 오류 없음.
revoke truncate, trigger, references
  on public.employee, public.receipt, public.receipt_item
  from anon, authenticated;
