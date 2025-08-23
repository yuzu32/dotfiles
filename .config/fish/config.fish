if not functions -q fundle; eval (curl -sfL https://git.io/fundle-install); end

fish_add_path ~/.local/bin

if status is-interactive
  set -g fish_greeting
  fish_vi_key_bindings

  # fundle plugins
  fundle plugin 'danhper/fish-ssh-agent'
  fundle init

  function fish_prompt
    set -l git_prompt (fish_git_prompt)
    if test "$git_prompt" = ""
      set git_prompt ''
    end
    printf '%s%s%s@%s %s%s%s%s%s> ' \
      (set_color brmagenta) $USER        \
      (set_color normal)    $hostname    \
      (set_color bryellow)  (prompt_pwd) \
      (set_color blue)      $git_prompt  \
      (set_color normal)
  end

  abbr --add nvims nvim -S .nvimsession
  abbr --add tmuxx tmux new -s default

  set fish_autosuggestion_enabled 0
end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /home/yamu/miniconda3/bin/conda
    eval /home/yamu/miniconda3/bin/conda "shell.fish" "hook" $argv | source
else
    if test -f "/home/yamu/miniconda3/etc/fish/conf.d/conda.fish"
        . "/home/yamu/miniconda3/etc/fish/conf.d/conda.fish"
    else
        set -x PATH "/home/yamu/miniconda3/bin" $PATH
    end
end
# <<< conda initialize <<<

