alias vi='nvim'
alias vim='nvim'

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# fbr - checkout git branch
fbr() {
  local branches branch
  branches=$(git branch -vv) &&
  branch=$(echo "${branches}" | fzf +m) &&
  git checkout $(echo "${branch}" | awk '{print $1}' | sed "s/.* //")
}

# fchromeh - browse chrome history
fchromeh() {
  local cols sep google_history open
  cols=$(( COLUMNS / 3 ))
  sep='{::}'

  if [ "$(uname)" = "Darwin" ]; then
    google_history="$HOME/Library/Application Support/Google/Chrome/Default/History"
    open=open
  else
    google_history="$HOME/.config/google-chrome/Default/History"
    open=xdg-open
  fi
  cp -f "$google_history" /tmp/h
  sqlite3 -separator $sep /tmp/h \
    "select substr(title, 1, $cols), url from urls order by last_visit_time desc" |
  awk -F $sep '{printf "%-'$cols's \x1b[36m%s\x1b[m\n", $1, $2}' |
  fzf --ansi --multi | sed 's#.*\(https*://\)#\1#' | xargs $open > /dev/null 2> /dev/null
}

source $HOME/.git-prompt.sh
source /Users/sho/alacritty/extra/completions/alacritty.bash
