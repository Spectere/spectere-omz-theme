# The humble beginnings of a ZSH theme. :)

sym_curved_rightarrow="\u2bab"
sym_zigzag="\u2b4d"
sym_branch="\ue0a0"
sym_ln="\ue0a1"
sym_lock="\ue0a2"
sym_cn="\ue0a3"
sym_rightarrow="\ue0b0"
sym_rightarrow_unfilled="\ueb1"
sym_leftarrow="\ue0b2"
sym_leftarrow_unfilled="\ueb3"
sym_rightcurve="\ue0b4"
sym_rightcurve_unfilled="\ue0b5"
sym_leftcurve="\ue0b6"
sym_leftcurve_unfilled="\ue0b7"
sym_downslope_bottom="\ue0b8"
sym_downslope_bottom_unfilled="\ue0b9"
sym_upslope_bottom="\ue0ba"
sym_upslope_bottom_unfilled="\ue0bb"
sym_upslope_top="\ue0bc"
sym_upslope_top_unfilled="\ue0bd"
sym_downslope_top="\ue0be"
sym_downslope_top_unfilled="\ue0bf"
sym_rightflame="\ue0c0"
sym_rightflame_unfilled="\ue0c1"
sym_leftflame="\ue0c2"
sym_leftflame_unfilled="\ue0c3"
sym_smallpixels_left="\ue0c4"
sym_smallpixels_right="\ue0c5"
sym_bigpixels_left="\ue0c6"
sym_bigpixels_right="\ue0c7"
sym_spikygraph_right="\ue0c8"
sym_spikygraph_left="\ue0ca"
sym_hexagons="\ue0cc"
sym_hexagons_unfilled="\ue0cd"
sym_lego_isoright="\ue0ce"
sym_lego_isoup="\ue0cf"
sym_lego_top="\ue0d0"
sym_lego_side_right="\ue0d1"
sym_funnel_left="\ue0d2"
sym_funnel_right="\ue0d4"

current_bg=0

# 1 - New background color.
sBg() {
	echo -n "%K{$1}"
	current_bg=$1
}

eBg() {
	echo -n "%k"
}

# 1 - Foreground color.
# 2 - Text to print.
p() {
	echo -n "%F{$1}$2%f"
}

# 1 - New background color.
sep() {
	local old_bg=$current_bg
	echo -n " "
	sBg $1
	p $old_bg "${sym_rightarrow}"
	echo -n " "
}

is_git() {
	if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
		echo 1
	else
		echo 0
	fi
}

is_root() {
	if [[ $UID -eq 0 || $EUID -eq 0 ]]; then
		echo 1
	else
		echo 0
	fi
}

# 1 - Username foreground.
# 2 - Hostname foreground.
# 3 - root lightning symbol foreground.
seg_username() {
	if [[ $(is_root) -gt 0 ]]; then
		echo -n "$(p $3 ${sym_zigzag}) "
	fi

	echo -n "$(p $1 '%n')"

	if [[ "${SSH_CLIENT}" != "" ]]; then
		echo -n "$(p $2 '@%m')"
	fi
}

# 1 - Path foreground.
seg_path() {
	p $1 "%~"
}

# 1 - Foreground.
seg_git() {
	local repo ref

	repo="$(git rev-parse --git-dir 2>/dev/null)"
	ref="${sym_branch} $(git symbolic-ref --short HEAD 2>/dev/null)" || ref="${sym_curved_rightarrow} $(git rev-parse --short HEAD 2>/dev/null)"

	p $1 "${ref}"

	if [[ -e "${repo}/BISECT_LOG" ]]; then
		p $1 " (B)"
	elif [[ -e "${repo}/MERGE_HEAD" ]]; then
		p $1 " (M)"
	elif [[ -e "${repo}/rebase" || -e "${repo}/rebase_apply" || -e "${repo}/rebase-merge" || -e "${repo}/../.dotest" ]]; then
		p $1 " (R)"
	fi
}

# The thing that puts all the things together into one larger thing!
prompt() {
	if [[ $(is_root) -gt 0 ]]; then
		# root user/sudoer
		sBg 52
	else
		# normal user
		sBg 55
	fi
	echo -n ' '
	seg_username 15 183 228
	sep 18
	seg_path 224

	if [[ $(is_git) -eq 1 ]]; then
		if [[ "$(parse_git_dirty)" != "" ]]; then
			sep 204
		else
			sep 48
		fi
		seg_git 0
	fi

	sep 0
}

PROMPT='$(prompt)'
