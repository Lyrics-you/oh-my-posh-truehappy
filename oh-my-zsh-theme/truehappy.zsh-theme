# Modify by ys theme
# Clean, simple, compatible and meaningful.
# Tested on Linux, Unix and Windows under ANSI colors.
# It is recommended to use with a dark background.
# Colors: black, red, green, yellow, *blue, magenta, cyan, and white.
#
# Mar 2023 lyrics

# VCS
# 你好
TH_VCS_PROMPT_PREFIX1=" %{$fg[red]%}on%{$fg[blue]%} "
TH_VCS_PROMPT_PREFIX2=":%{$fg[blue]%}"
TH_VCS_PROMPT_SUFFIX="%{$reset_color%}"
TH_VCS_PROMPT_DIRTY=" %{$fg[red]%}x"
TH_VCS_PROMPT_CLEAN=" %{$fg[green]%}o"

# Git info
# \uE0A0 powerline
local git_info='$(git_prompt_info)'
ZSH_THEME_GIT_PROMPT_PREFIX="${TH_VCS_PROMPT_PREFIX1}\uE0A0${TH_VCS_PROMPT_PREFIX2}"
ZSH_THEME_GIT_PROMPT_SUFFIX="$TH_VCS_PROMPT_SUFFIX"
ZSH_THEME_GIT_PROMPT_DIRTY="$TH_VCS_PROMPT_DIRTY"
ZSH_THEME_GIT_PROMPT_CLEAN="$TH_VCS_PROMPT_CLEAN"

# SVN info
local svn_info='$(svn_prompt_info)'
ZSH_THEME_SVN_PROMPT_PREFIX="${TH_VCS_PROMPT_PREFIX1}svn${TH_VCS_PROMPT_PREFIX2}"
ZSH_THEME_SVN_PROMPT_SUFFIX="$TH_VCS_PROMPT_SUFFIX"
ZSH_THEME_SVN_PROMPT_DIRTY="$TH_VCS_PROMPT_DIRTY"
ZSH_THEME_SVN_PROMPT_CLEAN="$TH_VCS_PROMPT_CLEAN"

# HG info
local hg_info='$(ys_hg_prompt_info)'
ys_hg_prompt_info() {
	# make sure this is a hg dir
	if [ -d '.hg' ]; then
		echo -n "${TH_VCS_PROMPT_PREFIX1}hg${TH_VCS_PROMPT_PREFIX2}"
		echo -n $(hg branch 2>/dev/null)
		if [[ "$(hg config oh-my-zsh.hide-dirty 2>/dev/null)" != "1" ]]; then
			if [ -n "$(hg status 2>/dev/null)" ]; then
				echo -n "$TH_VCS_PROMPT_DIRTY"
			else
				echo -n "$TH_VCS_PROMPT_CLEAN"
			fi
		fi
		echo -n "$TH_VCS_PROMPT_SUFFIX"
	fi
}

# Virtualenv
local venv_info='$(virtenv_prompt)'
TH_THEME_VIRTUALENV_PROMPT_PREFIX=" %{$fg[green]%}"
TH_THEME_VIRTUALENV_PROMPT_SUFFIX=" %{$reset_color%}%"
virtenv_prompt() {
	[[ -n "${VIRTUAL_ENV:-}" ]] || return
	echo "${TH_THEME_VIRTUALENV_PROMPT_PREFIX}${VIRTUAL_ENV:t}${TH_THEME_VIRTUALENV_PROMPT_SUFFIX}"
}

local exit_code="%(?,,C:%{$fg[red]%}%?%{$reset_color%})"

# Prompt format:
#
# PRIVILEGES USER in DIRECTORY on git:BRANCH STATE at [TIME] C:LAST_EXIT_CODE
# $ COMMAND
#
# For example:
#
# >>> lyrics in ~/.oh-my-zsh on git:master x at [21:47:42] C:0
# $

# green -> red -> cyan
PROMPT="
%{$terminfo[bold]$fg[green]%}>%{$terminfo[bold]$fg[red]%}>%{$terminfo[bold]$fg[cyan]%}>%{$reset_color%} \
%(#,%{$bg[red]%}%{$fg[black]%}%n%{$reset_color%},%{$fg[green]%}%n) \
%{$reset_color%}\
%{$fg[red]%}in \
%{$terminfo[bold]$fg[cyan]%}%~%{$reset_color%}\
${hg_info}\
${git_info}\
${svn_info}\
${venv_info}\
%{$fg[red]%} at %{$fg[yellow]%}\
[%*] $exit_code
%{$terminfo[bold]$fg[magenta]%}$ %{$reset_color%}"