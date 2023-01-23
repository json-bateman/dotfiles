#! /usr/bin/env bash

languages=$(echo "golang c cpp typescript rust" | tr " " "\n")
core_utils=$(echo "find xargs sed awk" | tr " " "\n")
selected=$(echo -e "$languages\n$core_utils" | fzf)

read -p "Enter query: " query

if echo "$languages" | grep -qs $selected; then
  tmux split-window -h bash -c "curl cht.sh/$selected/$(echo "$query" | tr " " "+") | less"
else 
  curl cht.sh/$selected~$query
fi

