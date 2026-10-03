@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"
title Publish to GitHub - Overengineered

echo.
echo  ==========================================================
echo    PUBLISH THIS FOLDER TO GITHUB
echo  ==========================================================
echo.

rem --- 1. Is Git installed? -------------------------------------
where git >nul 2>&1
if errorlevel 1 (
  echo  [X] Git is not installed, or not on your PATH.
  echo.
  echo      Install it from:  https://git-scm.com/download/win
  echo      Accept every default, close this window, then run me again.
  echo.
  pause
  exit /b 1
)

rem --- 2. Am I in the right folder? ------------------------------
if not exist "index.html" (
  echo  [X] index.html is not in this folder.
  echo.
  echo      This file must sit NEXT TO index.html, inside the
  echo      unzipped site folder. Move it there and run me again.
  echo.
  echo      Current folder: %CD%
  echo.
  pause
  exit /b 1
)

echo  Folder: %CD%
echo.

rem --- 3. Where are we pushing to? -------------------------------
set "OWNER=caservices53-hub"
set "REPO=overengineeredproducts"

set "ANS="
set /p "ANS=  GitHub username [%OWNER%]: "
if not "!ANS!"=="" set "OWNER=!ANS!"

set "ANS="
set /p "ANS=  Repository name  [%REPO%]: "
if not "!ANS!"=="" set "REPO=!ANS!"

echo.
echo  Target: https://github.com/!OWNER!/!REPO!
echo.

rem --- 4. Git needs a name and email on first use ----------------
set "GNAME="
for /f "tokens=*" %%a in ('git config --global user.name 2^>nul') do set "GNAME=%%a"
if not defined GNAME (
  echo  Git has not been set up on this PC yet.
  set /p "GNAME=  Your name:  "
  git config --global user.name "!GNAME!"
)

set "GMAIL="
for /f "tokens=*" %%a in ('git config --global user.email 2^>nul') do set "GMAIL=%%a"
if not defined GMAIL (
  set /p "GMAIL=  Your email: "
  git config --global user.email "!GMAIL!"
)

rem --- 5. First run, or an update? -------------------------------
if exist ".git" goto :UPDATE_RUN

echo.
echo  ----------------------------------------------------------
echo   FIRST RUN
echo  ----------------------------------------------------------
echo.
echo   The repository has to exist on GitHub before I can push.
echo.
echo     [1]  Open github.com/new so I can create it  (recommended)
echo     [2]  It already exists - just push
echo     [3]  Cancel
echo.

choice /c 123 /n /m "  Choose 1, 2 or 3: "
if errorlevel 3 goto :CANCELLED
if errorlevel 2 goto :FIRST_PUSH

echo.
echo   Opening github.com/new in your browser...
start "" "https://github.com/new"
echo.
echo   On that page:
echo     - Repository name:  !REPO!
echo     - Choose PUBLIC
echo     - Leave "Add a README file", "Add .gitignore" and
echo       "Choose a license" ALL UNCHECKED. This folder already
echo       has them, and ticking them will block the push.
echo     - Click "Create repository"
echo.
echo   Come back here when that is done.
echo.
pause

:FIRST_PUSH
echo.
echo  ----------------------------------------------------------
echo   Starting a new repository in this folder...
echo.
git init -q
if errorlevel 1 goto :GIT_FAILED
set "MSG=Initial commit - Overengineered studio site"
goto :STAGE

:UPDATE_RUN
echo.
echo  ----------------------------------------------------------
echo   This folder is already connected to GitHub.
echo.
set "ANS="
set /p "ANS=  Describe this change [Update site]: "
if "!ANS!"=="" set "ANS=Update site"
set "MSG=!ANS!"

:STAGE
echo.
echo   Staging files...
git add -A
if errorlevel 1 goto :GIT_FAILED

echo   Committing...
git commit -q -m "!MSG!"
if errorlevel 1 echo   Nothing new to commit - carrying on.

rem Rename the branch AFTER the first commit, so this works on
rem older Git versions too.
git branch -M main >nul 2>&1

echo   Pointing at GitHub...
git remote remove origin >nul 2>&1
git remote add origin "https://github.com/!OWNER!/!REPO!.git"
if errorlevel 1 goto :GIT_FAILED

echo.
echo   Pushing. A sign-in window or browser tab may open the
echo   first time - approve it, then come back here.
echo.
git push -u origin main
if errorlevel 1 goto :PUSH_FAILED

echo.
echo  ==========================================================
echo    DONE
echo  ==========================================================
echo.
echo    https://github.com/!OWNER!/!REPO!
echo.
echo    Next: tell Claude it is up, and the Vercel project gets
echo    linked so every future push deploys itself.
echo.
echo    To publish a change later: edit your files, then just
echo    double-click this file again.
echo.
start "" "https://github.com/!OWNER!/!REPO!"
pause
exit /b 0

rem --- Failures -------------------------------------------------
:PUSH_FAILED
echo.
echo  ==========================================================
echo    THE PUSH DID NOT GO THROUGH
echo  ==========================================================
echo.
echo    Git's own error is printed just above this box. The
echo    usual causes, in order of likelihood:
echo.
echo    1. The repository does not exist yet, or the name is
echo       spelled differently. Check:
echo       https://github.com/!OWNER!/!REPO!
echo.
echo    2. You ticked "Add a README file" when creating it, so
echo       GitHub has a commit this folder does not. Fix it by
echo       opening Git Bash here and running these two lines:
echo.
echo          git pull --rebase origin main
echo          git push -u origin main
echo.
echo    3. Sign-in was cancelled. Run me again and complete the
echo       GitHub sign-in when the window appears.
echo.
pause
exit /b 1

:GIT_FAILED
echo.
echo  [X] A Git command failed. Its error is printed above.
echo.
pause
exit /b 1

:CANCELLED
echo.
echo  Cancelled. Nothing was changed.
echo.
pause
exit /b 0
