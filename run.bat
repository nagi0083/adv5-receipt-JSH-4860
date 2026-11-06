@echo off
chcp 65001 > nul
setlocal
rem 경비 정산 웹앱 — 내 PC에서 확인용으로 띄운다 (R-15)
rem public 폴더만 http://127.0.0.1:8001 로 연다. 내 PC(127.0.0.1)에서만 열린다.

set "PORT=8001"
set "URL=http://127.0.0.1:%PORT%/"

if "%~1"==":open" goto :open

cd /d "%~dp0"

if not exist "public\index.html" (
  echo [오류] public\index.html 을 찾지 못했습니다. run.bat 이 프로젝트 폴더 바로 아래에 있는지 확인해 주세요.
  goto :fail
)

set "PY="
python --version > nul 2>&1 && set "PY=python"
if not defined PY (py -3 --version > nul 2>&1 && set "PY=py -3")
if not defined PY (
  echo [오류] Python 을 찾지 못했습니다. python.org 에서 Python 3 를 설치한 뒤 다시 실행해 주세요.
  goto :fail
)

netstat -ano | findstr /r /c:"127\.0\.0\.1:%PORT% .*LISTENING" /c:"0\.0\.0\.0:%PORT% .*LISTENING" > nul
if not errorlevel 1 (
  echo [오류] %PORT% 번 포트를 이미 다른 프로그램이 쓰고 있습니다.
  echo        이미 켜 둔 run.bat 창이 있으면 그 창을 쓰거나 닫은 뒤 다시 실행해 주세요.
  goto :fail
)

echo 경비 정산 화면을 내 PC에서 엽니다: %URL%
echo 확인이 끝나면 이 창을 닫으면 됩니다. (창을 닫아도 배포 주소는 영향 없음)
echo.

rem 서버가 준비되면 크롬을 여는 일은 따로 돌린다
start "" /b cmd /c ""%~f0" :open"

%PY% -m http.server %PORT% --bind 127.0.0.1 --directory public
echo.
echo [알림] 서버가 멈췄습니다. 위에 나온 내용을 확인해 주세요.
goto :fail

:open
rem 서버가 답할 때까지 최대 30초 기다린다
for /l %%i in (1,1,30) do (
  curl -s -o nul "%URL%" && goto :launch
  ping -n 2 127.0.0.1 > nul
)
echo [알림] 서버가 30초 안에 준비되지 않아 브라우저를 열지 않았습니다.
exit /b 1

:launch
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe" > nul 2>&1 && goto :chrome
reg query "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe" > nul 2>&1 && goto :chrome
echo [알림] 크롬을 찾지 못해 기본 브라우저로 엽니다.
start "" "%URL%"
exit /b 0

:chrome
start "" chrome "%URL%"
exit /b 0

:fail
echo.
pause
exit /b 1
