@echo off
REM ============================================================
REM  cmd-aliases.cmd
REM  Loaded by cmd-autorun.cmd on every cmd launch.
REM  Minimal — only uses built-in cmd + git (the only "extra" tool
REM  most setups already have on Windows).
REM ============================================================

REM ── cd shortcuts ───────────────────────────────────────────
doskey ..=cd ..
doskey ...=cd ..\..
doskey ....=cd ..\..\..
doskey home=cd /d %USERPROFILE%
doskey desk=cd /d %USERPROFILE%\Desktop
doskey dot=cd /d %USERPROFILE%\Desktop\dotfiles\dotfiles

REM ── ls family (eza: icons, colors, git badges) ─────────────
doskey ls=eza --icons --group-directories-first $*
doskey ll=eza -l  --icons --group-directories-first --git $*
doskey la=eza -la --icons --group-directories-first --git $*
doskey lt=eza --tree --level=2 --icons $*

REM ── Git ────────────────────────────────────────────────────
doskey gs=git status $*
doskey gd=git diff $*
doskey ga=git add $*
doskey gaa=git add -A $*
doskey gc=git commit -v $*
doskey gca=git commit --amend $*
doskey gcam=git commit -am $*
doskey gp=git push $*
doskey gpf=git push --force-with-lease $*
doskey gl=git pull $*
doskey gco=git checkout $*
doskey gcb=git checkout -b $*
doskey glog=git log --oneline --graph --decorate --all

REM ── Convenience ────────────────────────────────────────────
doskey reload=cmd /k
doskey edit-aliases=notepad %USERPROFILE%\cmd-aliases.cmd
doskey edit-starship=notepad %USERPROFILE%\.config\starship.toml

REM wtn — rename the current WezTerm tab from the shell.
REM Usage: wtn my-tab-name
doskey wtn=wezterm cli set-tab-title $*
