@echo off
setlocal enabledelayedexpansion

:: === ENTER YOUR DETAILS BELOW ===
set API_KEY=abc123
set API_SECRET=Xyzpqr987
set REQUEST_TOKEN=y8HejJ7TgPFSAlJ8n6elvAZGiFHZNyer
:: =================================

:: Step 1 - Create temp file with concatenated string
set TMPFILE=%TEMP%\kite_input.txt
echo|set /p="%API_KEY%%REQUEST_TOKEN%%API_SECRET%" > "%TMPFILE%"

:: Step 2 - Compute SHA256 using certutil
for /f "tokens=1,2 delims= " %%a in ('certutil -hashfile "%TMPFILE%" SHA256 ^| find /i /v "hash" ^| find /i /v "certutil"') do (
    set CHECKSUM=%%a
)
del "%TMPFILE%"

echo.
echo ✅ Generated Checksum:
echo %CHECKSUM%
echo.

:: Step 3 - Exchange for access token
echo 🔁 Requesting access token from Zerodha...
curl -s -X POST https://api.kite.trade/session/token ^
  -H "X-Kite-Version: 3" ^
  -H "Content-Type: application/x-www-form-urlencoded" ^
  -d "api_key=%API_KEY%&request_token=%REQUEST_TOKEN%&checksum=%CHECKSUM%"

echo.
echo ✅ Done!
pause
