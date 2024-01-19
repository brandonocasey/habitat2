#==============================================================
# => Bash Prompt
#
# Make your bash prompt look awesome, and make its colors
# differ if you are the root user
#==============================================================

# Fancy Shell

# if not root
if [ "$(id -u)" -ne 0 ]; then
  COLOR_TWO=$LIGHT_BLUE
  COLOR_THREE=$GREY
  COLOR_FOUR=$CYAN
  COLOR_FIVE=$LIGHT_BLUE
  UID_CHAR=">"
else
  COLOR_TWO=$RED
  COLOR_THREE=$ORANGE
  COLOR_FOUR=$YELLOW
  COLOR_FIVE=$BROWN
  UID_CHAR="$"
fi

get_git_branch() {
  # On branches, this will return the branch name
  # On non-branches, (no branch)
  ref="$(git symbolic-ref HEAD 2> /dev/null | sed -e 's~refs/heads/~~')"
  if [ -n "$ref" ]; then
    printf "%s" " [$ref]"
  fi
}

get_smiley() {
  if [ $? = 0 ]; then
    printf "%s" "${GREEN}✔${RESET}"
  else
    printf "%s" "${RED}✘${RESET}"
  fi
}

PS1=""

PS1+="\[\$(get_smiley)\]"     # Smiley face
PS1+="\[${WHITE}\]"           # Start the white color
PS1+=" \T "                   # Time
PS1+="\[${COLOR_THREE}\]"     # Start Color Three
PS1+="\u"                     # User
PS1+="\[${WHITE}\]"           # Start Color White
PS1+="@"                      # Just an at symbol
PS1+="\[${COLOR_FOUR}\]"      # Start Color 4
PS1+="\h"                     # Current hostname
PS1+="\[${WHITE}\]"           # Start Color White
PS1+=":"                      # colon
PS1+="\[${WHITE}\]"           # Start Color White
PS1+="\w"                     # Full pwd (working directory)
PS1+="\[${COLOR_THREE}\]"     # Start Color White
PS1+="\[\$(get_git_branch)\]" # current git branch or n/a
PS1+="\[${RESET}\]"           # Reset Color
PS1+="\n"                     # New Line
PS1+="\[${COLOR_FIVE}\]"      # Color five
PS1+="${UID_CHAR}"                     # > character
PS1+="\[${RESET}\]"           # Reset color
PS1+=" "                      # space

# disable cursor blink
printf '\033[?12l'
