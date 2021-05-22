#!/usr/bin/env bash
if [[ -n $LS_COLORS ]] ; then
  bat --color=always "$1"
else
  bat --color=always --theme=base16 "$1"
fi
