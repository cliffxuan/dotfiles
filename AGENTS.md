# Agent Guidelines for Dotfiles

## Tool and Package Installation
1. **Always default to `mise`**:
   - Before writing custom curl/install scripts, check if the tool is supported by `mise` (Aqua backend, GitHub releases, or native plugins):
     ```bash
     mise search <tool>
     mise ls-remote <tool>
     ```
   - If supported, declare the tool under `[tools]` in [`config/mise/config.toml`](config/mise/config.toml) (e.g. `<tool> = "latest"`).
   - Only use direct installer scripts (`curl | sh`) if `mise` does not support the tool.

## Creating New Modules (`modules/<number>-<name>.sh`)
When a new tool requires shell completion, post-install steps, or configuration linking:
1. **Module Structure**:
   - Source `../utils.sh`.
   - Implement `run()` and `check()` functions.
   - Conclude with `provision "$@"`.
2. **Installation in `run()`**:
   - Run `mise install <tool>` and `mise reshim`.
   - Generate any shell completions into `~/.zfunc/_<tool>`.
3. **Verification in `check()`**:
   - Check `command -v <tool>` (or `mise which <tool>`) and verify completion files exist and are non-empty.
4. **Code Quality**:
   - Ensure scripts pass `shellcheck -x` and are formatted with `shfmt`.
