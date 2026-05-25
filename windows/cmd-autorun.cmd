@echo off
REM ============================================================
REM  cmd-autorun.cmd
REM  Set as cmd's AutoRun via `clink autorun set` (see install.bat).
REM  Runs on every cmd launch — loads Clink + aliases + cmd-tuned
REM  Starship config (lean: no git_status, no language version checks).
REM ============================================================

REM Point Starship at the cmd-tuned config (lean, no slow modules).
@set "STARSHIP_CONFIG=%USERPROFILE%\.config\starship-cmd.toml"

@call "%USERPROFILE%\scoop\apps\clink\current\clink.bat" inject --autorun
@if exist "%USERPROFILE%\cmd-aliases.cmd" call "%USERPROFILE%\cmd-aliases.cmd"
