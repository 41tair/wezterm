if [[ -r "$HOME/.zshrc" ]]; then
  source "$HOME/.zshrc"
fi

if [[ -n "${WEZTERM_LAYOUT_COMMAND:-}" && -z "${WEZTERM_LAYOUT_COMMAND_STARTED:-}" ]]; then
  export WEZTERM_LAYOUT_COMMAND_STARTED=1

  __wezterm_layout_command="$WEZTERM_LAYOUT_COMMAND"
  __wezterm_layout_cwd="${WEZTERM_LAYOUT_CWD:-$PWD}"
  __wezterm_layout_command_env="${WEZTERM_LAYOUT_COMMAND_ENV:-}"
  unset WEZTERM_LAYOUT_COMMAND WEZTERM_LAYOUT_CWD WEZTERM_LAYOUT_COMMAND_ENV

  if builtin cd -- "$__wezterm_layout_cwd"; then
    if [[ -n "$__wezterm_layout_command_env" ]]; then
      eval "$__wezterm_layout_command_env"
    fi

    print -r -- "[wezterm layout] $ $__wezterm_layout_command"
    eval "$__wezterm_layout_command"
    __wezterm_layout_status=$?
    print
    print -r -- "[wezterm layout] command exited with status $__wezterm_layout_status"
  else
    print -u2 -r -- "[wezterm layout] cannot cd to $__wezterm_layout_cwd"
  fi

  unset WEZTERM_LAYOUT_COMMAND_STARTED
  unset __wezterm_layout_command __wezterm_layout_cwd __wezterm_layout_command_env __wezterm_layout_status
fi
