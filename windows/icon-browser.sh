#!/usr/bin/env bash
# icon-browser.sh
# Prints a curated set of Nerd Font icons across multiple sets (nf-fa-*,
# nf-dev-*, nf-custom-*, nf-cod-*) so you can SEE which ones render in
# your terminal and pick favorites for tmux window names.
#
# Usage:  bash icon-browser.sh
#
# Each row:  <glyph>   <human-name>   U+<codepoint>   <printf-bytes>
# An empty box □ means your font doesn't have that codepoint — pick another.

print_icon() {
    local bytes="$1" name="$2" cp="$3"
    printf '  %b  %-30s  U+%-5s  %s\n' "$bytes" "$name" "$cp" "$bytes"
}

section() {
    printf '\n\033[1;35m── %s ──\033[0m\n' "$1"
}

section "EDITOR — Nvim / Vim specific"
print_icon '\xee\x98\xab' 'nf-custom-neovim'         E62B
print_icon '\xee\x9f\x85' 'nf-custom-vim'            E7C5
print_icon '\xee\x9e\x96' 'nf-dev-vim'               E796
print_icon '\xef\x81\x80' 'nf-fa-pencil'             F040
print_icon '\xef\x81\x84' 'nf-fa-pencil-square'      F044
print_icon '\xef\x83\xb6' 'nf-fa-file-text-o'        F0F6

section "TERMINAL — Shell / .sh"
print_icon '\xee\xaf\x8a' 'nf-cod-terminal-bash'     EBCA
print_icon '\xee\x9e\x95' 'nf-dev-terminal'          E795
print_icon '\xee\x9e\x91' 'nf-dev-bash'              E791
print_icon '\xee\xaa\x85' 'nf-cod-terminal'          EA85
print_icon '\xef\x84\xa0' 'nf-fa-terminal'           F120
print_icon '\xef\x84\xa1' 'nf-fa-code'               F121
print_icon '\xee\x95\x80' 'nf-seti-shell'            E540

section "CMD — Windows / .bat"
print_icon '\xee\xaf\x84' 'nf-cod-terminal-cmd'      EBC4
print_icon '\xee\x9c\x8f' 'nf-dev-windows'           E70F
print_icon '\xef\x85\xba' 'nf-fa-windows'            F17A
print_icon '\xee\xaf\x87' 'nf-cod-terminal-powershell' EBC7

section "LOGS — files / lists / output"
print_icon '\xee\xae\x9d' 'nf-cod-output'            EB9D
print_icon '\xee\xaa\x82' 'nf-cod-history'           EA82
print_icon '\xee\xad\xae' 'nf-cod-list-tree'         EB6E
print_icon '\xee\xaa\x84' 'nf-cod-pulse'             EA84
print_icon '\xef\x80\xad' 'nf-fa-book'               F02D
print_icon '\xef\x80\xba' 'nf-fa-list-ol'            F03A
print_icon '\xef\x83\x89' 'nf-fa-bars'               F0C9
print_icon '\xef\x83\xb6' 'nf-fa-file-text-o'        F0F6
print_icon '\xef\x86\x87' 'nf-fa-archive'            F187
print_icon '\xef\x81\xbb' 'nf-fa-folder'             F07B
print_icon '\xef\x81\xbc' 'nf-fa-folder-open'        F07C

section "AGENT — bots / AI / sparkles"
print_icon '\xee\xae\xa4' 'nf-cod-hubot'             EBA4
print_icon '\xee\xae\x8e' 'nf-cod-zap'               EB8E
print_icon '\xee\xad\xba' 'nf-cod-sparkle'           EB7A
print_icon '\xee\xaf\xa9' 'nf-cod-debug-alt'         EBE9
print_icon '\xef\x85\xbb' 'nf-fa-android'            F17B
print_icon '\xef\x84\xb5' 'nf-fa-rocket'             F135
print_icon '\xef\x83\x90' 'nf-fa-magic'              F0D0
print_icon '\xef\x8b\x9b' 'nf-fa-microchip'          F2DB
print_icon '\xef\x83\xa7' 'nf-fa-bolt'               F0E7
print_icon '\xef\x82\x85' 'nf-fa-cogs'               F085
print_icon '\xef\x83\x83' 'nf-fa-flask'              F0C3
print_icon '\xef\x86\x88' 'nf-fa-bug'                F188

section "FILE TYPES — by language"
print_icon '\xee\x9e\x84' 'nf-dev-python'            E73C
print_icon '\xee\x99\xa6' 'nf-custom-go'             E626
print_icon '\xee\x9e\xa8' 'nf-dev-rust'              E7A8
print_icon '\xee\x9b\x91' 'nf-dev-nodejs-small'      E718
print_icon '\xee\x9e\xa7' 'nf-dev-typescript'        E628
print_icon '\xee\x99\x91' 'nf-custom-c'              E61E
print_icon '\xee\x99\xa1' 'nf-custom-cpp'            E61D
print_icon '\xee\x9e\xa6' 'nf-dev-docker'            E7B0
print_icon '\xee\x9e\xb4' 'nf-dev-database'          E706

section "DEV — code / git / branches"
print_icon '\xee\xaa\x88' 'nf-cod-git-branch'        EA68
print_icon '\xee\xaa\x99' 'nf-cod-git-commit'        EA99
print_icon '\xee\xaa\x9e' 'nf-cod-git-merge'         EA9E
print_icon '\xee\xab\x95' 'nf-cod-source-control'    EB14
print_icon '\xef\x84\x96' 'nf-fa-code-fork'          F126
print_icon '\xef\x82\xab' 'nf-fa-folder-open-o'      F115

section "STATUS — check / cross / star"
print_icon '\xef\x80\x84' 'nf-fa-check'              F00C
print_icon '\xef\x80\x8d' 'nf-fa-heart'              F004
print_icon '\xef\x80\xa0' 'nf-fa-star'               F005
print_icon '\xef\x84\xa6' 'nf-fa-check-circle'       F058
print_icon '\xee\xaa\x86' 'nf-cod-check'             EA86

section "MISC"
print_icon '\xef\x83\xa9' 'nf-fa-globe'              F0AC
print_icon '\xef\x80\xa3' 'nf-fa-flag'               F024
print_icon '\xef\x84\xab' 'nf-fa-paper-plane'        F1D8
print_icon '\xef\x80\xae' 'nf-fa-camera'             F030
print_icon '\xef\x80\xa9' 'nf-fa-cog'                F013
print_icon '\xef\x82\x9c' 'nf-fa-wrench'             F0AD
print_icon '\xef\x84\xb6' 'nf-fa-bell'               F0F3
print_icon '\xef\x82\xa6' 'nf-fa-clock-o'            F017
print_icon '\xef\x83\xa3' 'nf-fa-search'             F002
print_icon '\xef\x80\xa2' 'nf-fa-home'               F015
print_icon '\xef\x80\xb1' 'nf-fa-key'                F084

printf '\n\033[1;32mHow to use one:\033[0m\n'
printf '  Copy the bytes from the last column, e.g. for nvim icon:\n'
printf '    n_editor=$(printf '\''\\xee\\x98\\xab'\'')\n\n'
printf '\033[1;33mIf a row shows empty □ \033[0m your font is missing that glyph — pick another row.\n\n'
