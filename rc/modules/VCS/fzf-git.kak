# ╭─────────────╥─────────────────────────╮
# │ Author:     ║ File:                   │
# │ Andrey Orst ║ fzf-svn.kak             │
# ╞═════════════╩═════════════════════════╡
# │ Submodule for Git support for fzf.kak │
# ╞═══════════════════════════════════════╡
# │ GitHub.com/andreyorst/fzf.kak         │
# ╰───────────────────────────────────────╯

declare-option -docstring "command to provide list of files in git tree to fzf. Arguments are supported
Supported tools:
    <package>: <value>:
    Git :      ""git""

Default arguments:
    ""git ls-tree --full-tree --name-only -r HEAD""
" \
str fzf_git_command "git"

try %{ declare-user-mode fzf-vcs }
map global fzf-vcs -docstring "edit file from Git tree" 'g' '<esc>: fzf-git<ret>'

define-command -override -hidden fzf-git %{ evaluate-commands %sh{
    current_path=$(pwd)
    repo_root=$(git rev-parse --show-toplevel)
    case $kak_opt_fzf_git_command in
    git)
        cmd="git ls-tree --full-tree --name-only -r HEAD" ;;
    git*)
        cmd=$kak_opt_fzf_git_command ;;
    esac
    [ ! -z "${kak_client_env_TMUX}" ] && additional_flags="--expect ctrl-v --expect ctrl-s"
    printf "%s\n" "fzf -kak-cmd %{cd $repo_root; edit -existing} -items-cmd %{$cmd} -fzf-args %{-m --expect ctrl-w $additional_flags} -post-action %{cd $current_path}"
}}

