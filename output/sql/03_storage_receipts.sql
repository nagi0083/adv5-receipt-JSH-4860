-- 03 비공개 사진 저장소 receipts (A-01 · R-03, R-11) — 실행: 2026-11-06 (마이그레이션 03_storage_receipts)
-- 다시 실행해도 오류 없음: 저장소 · 정책이 이미 있으면 건너뛴다(설정을 덮어쓰지 않는다).
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('receipts', 'receipts', false, 10485760,
        array['image/jpeg','image/png','image/webp'])
on conflict (id) do nothing;

do $$
begin
  if not exists (select 1 from pg_policies where schemaname = 'storage' and tablename = 'objects' and policyname = 'receipts_upload_web') then
    create policy receipts_upload_web on storage.objects for insert to anon
      with check (bucket_id = 'receipts'
              and name ~ '^web_[0-9]{8}_[0-9]{6}_[a-z0-9]{4}\.(jpg|jpeg|png|webp)$');
  end if;
  if not exists (select 1 from pg_policies where schemaname = 'storage' and tablename = 'objects' and policyname = 'receipts_read') then
    create policy receipts_read on storage.objects for select to anon
      using (bucket_id = 'receipts');
  end if;
end $$;
