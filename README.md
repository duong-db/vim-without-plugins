# vim-without-plugins

> A minimal Vim setup built entirely on Vim’s native features — no plugins, no plugin manager.

## Main Features

- Neovim-like dynamic cursor shapes  
- Recursive file search with native tab completion 
- Enhanced Netrw (vim-vinegar style navigation + auto `cd` on quit)


## Installation

- Add `.vimrc` to your home directory
```bash
${HOME}/.vimrc
```

- (Optional) Add the following to your `${HOME}/.bashrc` to enable **cd-on-quit** behavior:

```bash
export VIM_LASTDIR_FILE="${HOME}/.vim_lastdir"

vim() {
    command vim "$@"
    if [[ -f "$VIM_LASTDIR_FILE" ]]; then
        local last_dir=$(cat "$VIM_LASTDIR_FILE")
        if [[ -d "$last_dir" ]]; then
            cd "$last_dir"
        fi
    fi
}
```
## Usage

### 1. Neovim-Style Cursor

Different cursor shapes for each mode:

- Normal mode → Block cursor  
- Insert mode → Vertical bar  
- Replace mode → Underline  

Works in most modern terminals that support cursor shape escape sequences.

---

### 2. Recursive File Search

Search files recursively from the current working directory:

```vim
:find filename
:find *partial*
```

Press `<Tab>` to cycle through matches.

---

### 3. Enhanced Netrw  
*(Vim-vinegar style navigation + auto cd-on-quit)*

Open the file explorer:

```bash
vim .
```

#### **Navigation**
- `<Enter>`: Open a file or enter a directory  
- `-`: Go to parent directory (vim-vinegar style) 
- `j`, `k`: Move down/up   
- `gh`: Toggle hidden files and directories
- `gx`: Open a file with `xdg-open`
- `/`: Search by name (`n` / `<Shift+n>` to navigate matches)
- `!<command>`: Run a custom shell command
- `<Ctrl+l>`: Refresh the directory listing

For additional commands, see the built-in Netrw help.

#### **cd-on-quit**
When quitting Vim from a Netrw buffer, your shell automatically switches to the last directory recorded during the session.

This allows Vim to function as a lightweight directory navigator, making it especially convenient when exploring projects directly from the terminal.