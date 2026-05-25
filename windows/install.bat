@echo off
REM ============================================================
REM  windows\install.bat
REM  One-shot setup for a "pretty cmd" environment on Windows.
REM  Run from any cmd: install.bat   (no admin needed)
REM
REM  Installs:
REM    - scoop (package manager — userland, no admin)
REM    - clink (modern features for cmd)
REM    - starship (prompt — same as WSL setup)
REM    - eza, fd, ripgrep, fzf, bat, lazygit, delta, zoxide, gh
REM    - neovim
REM
REM  Deploys:
REM    - cmd-aliases.cmd      → %USERPROFILE%
REM    - clink-prompt.lua     → %USERPROFILE%
REM    - starship.toml        → %USERPROFILE%\.config\starship.toml
REM    - nvim config          → %LOCALAPPDATA%\nvim
REM    - Clink autorun        → loads aliases on every cmd launch
REM ============================================================

setlocal enabledelayedexpansion
echo.
echo === Windows cmd setup ===
echo.

REM ── Locate the dotfiles directory (this script's parent's parent) ──
set "DOTFILES=%~dp0..\"
for %%I in ("%DOTFILES%") do set "DOTFILES=%%~fI"
echo Dotfiles    : %DOTFILES%
echo User home   : %USERPROFILE%
echo Config dir  : %USERPROFILE%\.config
echo.

REM ── Install scoop if missing ────────────────────────────────
REM `where scoop` checks PATH; on a fresh parent shell scoop is on disk
REM but not yet in PATH. Also check the canonical install location so we
REM don't pointlessly re-extract scoop every run.
if exist "%USERPROFILE%\scoop\shims\scoop.cmd" (
    echo scoop already installed - skipping
) else (
    where scoop >nul 2>nul
    if errorlevel 1 (
        echo Installing scoop...
        powershell -NoProfile -ExecutionPolicy Bypass -Command "iwr -useb get.scoop.sh | iex"
    )
)

REM ── Make scoop usable in THIS cmd session ───────────────────
REM A fresh PATH from a parent process doesn't include scoop's shims dir
REM (it gets picked up only by new cmd windows). Prepend it explicitly.
set "PATH=%USERPROFILE%\scoop\shims;%PATH%"

REM ── Add the 'extras' bucket which has lazygit, delta, etc. ──
REM IMPORTANT: scoop is a .cmd shim. Invoking it from a .bat without `call`
REM replaces the caller and ends this script after the first invocation.
echo Adding scoop buckets...
call scoop bucket add extras
call scoop bucket add nerd-fonts

REM ── Install only the essentials via scoop ───────────────────
REM Three tools — what's strictly needed for the aesthetic:
REM   clink    — modern features for cmd + Lua for prompt theming
REM   starship — the prompt itself
REM   eza      — pretty `ls` with icons, colors, git badges
echo.
echo Installing essentials via scoop...
for %%P in (clink starship eza) do (
    echo.
    echo --- scoop install %%P ---
    call scoop install %%P
)

REM ── Deploy alias file ───────────────────────────────────────
echo.
echo Deploying cmd-aliases.cmd...
copy /Y "%~dp0cmd-aliases.cmd" "%USERPROFILE%\cmd-aliases.cmd" >nul
echo   - %USERPROFILE%\cmd-aliases.cmd

REM ── Deploy clink prompt loader ──────────────────────────────
echo.
echo Deploying clink-prompt.lua...
if not exist "%LOCALAPPDATA%\clink\" mkdir "%LOCALAPPDATA%\clink"
copy /Y "%~dp0clink-prompt.lua" "%LOCALAPPDATA%\clink\starship.lua" >nul
echo   - %LOCALAPPDATA%\clink\starship.lua

REM ── Deploy starship configs ─────────────────────────────────
echo.
echo Deploying starship configs...
if not exist "%USERPROFILE%\.config\" mkdir "%USERPROFILE%\.config"
REM Default (used by zsh under WSL — the full-featured prompt)
if exist "%DOTFILES%\zsh\starship.toml" (
    copy /Y "%DOTFILES%\zsh\starship.toml" "%USERPROFILE%\.config\starship.toml" >nul
    echo   - %USERPROFILE%\.config\starship.toml         (default, zsh under WSL)
)
REM Cmd-tuned (no git_status, no language version checks — fast).
REM Activated by STARSHIP_CONFIG env var set in cmd-autorun.cmd.
copy /Y "%~dp0starship-cmd.toml" "%USERPROFILE%\.config\starship-cmd.toml" >nul
echo   - %USERPROFILE%\.config\starship-cmd.toml     (lean cmd-tuned prompt)

REM ── Deploy cmd-autorun wrapper ──────────────────────────────
REM This wrapper loads Clink + the aliases when cmd starts. Point cmd's
REM AutoRun at it (one entry can chain both — clink's autorun-install only
REM injects clink itself, losing the aliases).
echo.
echo Deploying cmd-autorun wrapper...
copy /Y "%~dp0cmd-autorun.cmd" "%USERPROFILE%\cmd-autorun.cmd" >nul
echo   - %USERPROFILE%\cmd-autorun.cmd

REM ── Set cmd's AutoRun to our wrapper ────────────────────────
echo.
echo Configuring cmd AutoRun (loads Clink + aliases on every cmd launch)...
call clink autorun set "%USERPROFILE%\cmd-autorun.cmd"

REM ── Tune Clink for faster startup + lower per-keystroke cost ──
REM autosuggest.enable      — disables ghost-text suggestions (saves CPU per keystroke)
REM history.shared          — off avoids cross-process history sync overhead
REM match.coloring_rules    — empty avoids per-line coloring of completion menus
echo.
echo Tuning Clink settings for speed...
call clink set autosuggest.enable false
call clink set history.shared false

REM ── Done ────────────────────────────────────────────────────
echo.
echo ============================================
echo  Setup complete.
echo  Close this cmd and open a new one to see:
echo    - starship prompt
echo    - aliases (ls, gs, gc, vim, ...)
echo    - tab completion + history
echo ============================================
echo.
endlocal
