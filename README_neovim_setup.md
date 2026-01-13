# Neovim Kickstart Setup Script

This repository contains a fully automated bash script to set up a modern, fast, and highly productive Neovim configuration based on **[nvim-lua/kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)** (as of December 30, 2025).

The script combines the best of Kickstart.nvim with popular community additions (inspired by ThePrimeagen, typecraft, and TJ DeVries) and personal preferences for a polished out-of-the-box experience.

### About This Project

This setup script (and the accompanying README and cheat sheet) was collaboratively generated with the help of three leading AI assistants:

- **Grok** (by xAI) – primary architect and maintainer of the conversation flow, script logic, and final refinements
- **Gemini** (by Google) – contributed ideas, structure suggestions, and validation
- **ChatGPT** (by OpenAI) – provided early brainstorming, alternative approaches, and detailed explanations

The result is a community-driven, AI-assisted configuration that brings together the best practices from top Neovim creators while adding thoughtful customizations.

### What's Included

- **Base**: Latest Kickstart.nvim (minimal, well-commented, single-file `init.lua`)
- **Colorscheme**: Catppuccin (mocha flavour) – cozy, modern, and highly integrated
- **Navigation**: Harpoon2 – lightning-fast file bookmarking
- **Undo History**: Undotree – visual undo tree
- **Git Integration**: vim-fugitive – the best Git wrapper for Vim/Neovim
- **Custom Options**: Modern editor settings (relative numbers, clipboard, inccommand, etc.)
- **Custom Keymaps**: Handy diagnostic mappings and `<Esc>` to clear search highlight
- **All Core Kickstart Features**:
  - Telescope (fuzzy finding)
  - Treesitter (syntax highlighting & more)
  - LSP support (Mason + lspconfig)
  - Autocompletion (nvim-cmp + LuaSnip)
  - Formatting (conform.nvim)
  - Gitsigns, Which-key, autopairs, and more

### Prerequisites

- Neovim 0.9+ (preferably latest stable or nightly)
- Git
- A Nerd Font installed and set in your terminal (for icons)
- Recommended: ripgrep (`rg`) and `fd` for better Telescope performance

### Installation

1. Save the script to your machine:

   ```bash
   curl -LO https://raw.githubusercontent.com/yourusername/yourrepo/main/setup-kickstart.sh
   # Or copy the script content manually into a file
   ```

2. Make it executable:

   ```bash
   chmod +x setup-kickstart.sh
   ```

3. Run it:

   ```bash
   ./setup-kickstart.sh
   ```

   The script will:
   - Back up any existing `~/.config/nvim` (with timestamp)
   - Remove old plugin data
   - Clone kickstart.nvim
   - Insert custom plugins, options, and keymaps
   - Finish with clear next-step instructions

4. Open Neovim:

   ```bash
   nvim
   ```

   lazy.nvim will automatically install all plugins (takes 1–2 minutes).  
   You can monitor progress with `:Lazy`.

5. Verify everything works:

   ```vim
   :checkhealth
   ```

You're done! Enjoy a fast, IDE-like Neovim experience.

### Customization

Everything lives in `~/.config/nvim/init.lua`.  
The file is heavily commented — feel free to tweak, add plugins, or modularize further.

Tip: Fork the kickstart.nvim repo first, then clone your fork for better version control of your changes.

---

## Neovim Keymap Cheat Sheet

**Leader key:** `<Space>`  
Press `<Space>?` anytime to see available bindings (thanks to which-key.nvim).

### Core Neovim Modes

| Mode      | Enter              | Exit             | Purpose                 |
|-----------|--------------------|------------------|-------------------------|
| Normal    | `<Esc>` or `<C-[>` | -                | Navigation & commands   |
| Insert    | `i`, `a`, `o`,     | `<Esc>`          | Typing text             |
|           | `I`, `A`, `O`      | `<Esc>`          | Typing text             |
| Visual    | `v` (char),        | `<Esc>`          | Select text             |
| Visual    | `V` (line),        | `<Esc>`          | Select text             |
| Visual    | `<C-v>` (block)    | `<Esc>`          | Select text             |
| Command   | `:`                | `<Enter>` or     | Ex commands             |
|           |                    | `<Esc>`          |                         |
| Replace   | `R`                | `<Esc>`          | Overwrite text          |

### Core Neovim Basic Navigation

| Keys              | Action                                      |
|-------------------|---------------------------------------------|
| `h j k l`         | Left, down, up, right                       |
| `w` / `b`         | Next/previous word                          |
| `e`               | End of word                                 |
| `0` / `^` / `$`   | Start of line / first char / end of line    |
| `gg` / `G`        | Top / bottom of file                        |
| `<C-u>` / `<C-d>` | Half-page up / down                         |
| `<C-b>` / `<C-f>` | Full-page up / down                         |
| `{` / `}`         | Previous / next paragraph                   |
| `%`               | Jump to matching parenthesis                |

### Core Neovim Editing

| Keys              | Action                                      |
|-------------------|---------------------------------------------|
| `i` / `a`         | Insert before / after cursor                |
| `o` / `O`         | New line below / above                      |
| `x` / `dd`        | Delete char / line                          |
| `D` / `C`         | Delete to EOL / change to EOL               |
| `yy` / `p`        | Yank line / paste                           |
| `u` / `<C-r>`     | Undo / redo                                 |
| `.`               | Repeat last edit                            |
| `~`               | Toggle case                                 |
| `J`               | Join lines                                  |

### Core Neovim Visual Mode

| Keys                | Action                                    |
|---------------------|-------------------------------------------|
| `v` / `V` / `<C-v>` | Character / line / block visual           |
| `o`                 | Go to other end of selection              |
| `>`, `<`            | Indent / outdent selection                |
| `y` / `d` / `p`     | Yank / delete / paste selection           |

### Core Neovim Files & Buffers

| Command / Key     | Action                                      |
|-------------------|---------------------------------------------|
| `:e filename`     | Open file                                   |
| `:w` / `:q`       | Save / quit                                 |
| `:wq` / `ZZ`      | Save & quit                                 |
| `:q!`             | Quit without saving                         |
| `:bnext` / `:bprev` | Next / previous buffer                    |
| `:bd`             | Delete buffer                               |
| `:ls` / `:buffers`| List buffers                                |

### Core Neovim Search, Replace & Sort

| Keys / Command    | Action                                      |
|-------------------|---------------------------------------------|
| `/` / `?`         | Search forward / backward                   |
| `n` / `N`         | Next / previous match                       |
| `*` / `#`         | Search word under cursor forward/backward   |
| `:%s/old/new/g`   | Replace all                                 |
| `:%s/old/new/gc`  | Replace with confirm                        |
| `:%sort`          | Sort all lines                              |
| `:10,20sort`      | Sort lines 10–20                            |


### Custom Diagnostic & Utility Keymaps

| Mode | Key         | Action                     | Description               |
|------|-------------|----------------------------|---------------------------|
| n    | `<Esc>`     | `:nohlsearch`              | Clear search highlight    |
| n    | `[d`        | Previous diagnostic        | Go to prev error/warning  |
| n    | `]d`        | Next diagnostic            | Go to next error/warning  |
| n    | `<leader>e` | `vim.diagnostic.open_float`| Show line diagnostics     |
| n    | `<leader>q` | `vim.diagnostic.setloclist`| Open diagnostic quickfix  |
|      |             |                            | list                      |

### Telescope (Fuzzy Finder)

| Mode | Key         | Action         | Description                           |
|------|-------------|----------------|---------------------------------------|
| n    | `<leader>ff`| Find files     | Search files in project               |
| n    | `<leader>fg`| Live grep      | Search text in files                  |
| n    | `<leader>fb`| Buffers        | Switch open buffers                   |
| n    | `<leader>fh`| Help tags      | Search Neovim help                    |
| n    | `<leader>gf`| Git files      | Files tracked by Git                  |
| n    | `<leader>sk`| Keymaps        | Search all keybindings (great cheat!) |
| n    | `<leader>ss`| LSP document   | Symbols in current file               |
|      |             | Symbols        |                                       |

### LSP (Active when language server is attached)

| Mode | Key         | Action          | Description                          |
|------|-------------|-----------------|--------------------------------------|
| n    | `gd`        | Goto definition | Jump to definition                   |
| n    | `gr`        | References      | Find references                      |
| n    | `gI`        | Implementations | Find implementations                 |
| n    | `gy`        | Type definition | Jump to type definition              |
| n    | `K`         | Hover           | Show documentation                   |
| n    | `<leader>ca`| Code actions    | Fix/refactor options                 |
| n    | `<leader>rn`| Rename symbol   | Rename across project                |

### Formatting

| Mode | Key         | Action          | Description                          |
|------|-------------|-----------------|--------------------------------------|
| n    | `<leader>gf`| Format buffer   | Auto-format current file             |

### Harpoon2 (File Bookmarking)

| Mode | Key         | Action          | Description                          |
|------|-------------|-----------------|--------------------------------------|
| n    | `<leader>a` | Add current file| Mark file                            |
| n    | `<leader>h` | Toggle menu     | Open Harpoon menu                    |
| n    | `<leader>1`–| Goto file 1–4   | Quick jump to marked files           |
|      | `<leader>4` | Goto file 1–4   | Quick jump to marked files           |
| n    | `<C-S-P>`   | Previous marked | Cycle backward                       |
|      |             | file            |                                      |
| n    | `<C-S-N>`   | Next marked     | Cycle forward                        |
|      |             | file            |                                      |

### Undotree

| Mode | Key         | Action            | Description                        |
|------|-------------|-------------------|------------------------------------|
| n    | `<leader>u` | `:UndotreeToggle` | Toggle visual undo tree            |

### vim-fugitive (Git)

| Mode | Key         | Action            | Description                        |
|------|-------------|-------------------|------------------------------------|
| n    | `<leader>gs`| `:Git`            | Open Git status window             |

**Useful Fugitive commands** (type in command mode):
- `:Git push`, `:Git pull`, `:Gblame`, `:Gdiffsplit`, `:Gbrowse`

### Autocompletion (nvim-cmp)

| Mode | Key               | Action                                      |
|------|-------------------|---------------------------------------------|
| i    | `<C-Space>`       | Trigger completion                          |
| i    | `<CR>`            | Confirm selection                           |
| i    | `<C-y>`           | Confirm                                     |
| i    | `<C-e>`           | Abort                                       |
| i    | `<C-n/p>`         | Next / previous item                        |
| i    | `<C-b/f>`         | Scroll docs up / down                       |

### Surround (mini.surround)

| Key               | Action                                      |
|-------------------|---------------------------------------------|
| `sa`              | Add surround (e.g., `sa iw (` )             |
| `sd`              | Delete surround                             |
| `sr`              | Replace surround                            |
| `sh`              | Highlight surround                          |

### Terminal & Window Management

| Key               | Action                                      |
|-------------------|---------------------------------------------|
| `<C-w> s/h/v`     | Split horizontal / vertical / vertical      |
| `<C-w> w`         | Cycle windows                               |
| `<C-w> q`         | Close window                                |
| `:term` or `:terminal` | Open terminal                          |
| In terminal: `<C-\><C-n>` | Back to normal mode                 |

### File Explorer (Netrw – built-in)

| Command           | Action                                      |
|-------------------|---------------------------------------------|
| `:Ex` or `:Explore`| Open Netrw in current dir                  |
| `-`               | Go up directory                             |
| `%`               | Create new file                             |
| `d`               | Create directory                            |
| `R`               | Rename                                      |
| `D`               | Delete                                      |

### Treesitter & Textobjects (nvim-treesitter-textobjects)

Provides better highlighting and advanced selections:
- `af` / `if`       → function outer/inner
- `ac` / `ic`       → class outer/inner
- `a/` / `i/`       → comment (with Comment.nvim)

### Lazy.nvim (Plugin Manager)

| Command           | Action                                      |
|-------------------|---------------------------------------------|
| `:Lazy`           | Open manager UI                             |
| `:Lazy sync`      | Install/update plugins                      |
| `:Lazy clean`     | Remove unused plugins                       |
| `:Lazy check`     | Check for updates                           |

### Mason & LSP Management

| Command           | Action                                      |
|-------------------|---------------------------------------------|
| `:Mason`          | UI for LSP servers, formatters, linters     |
| `:LspInfo`        | Show attached LSPs                          |
| `:LspRestart`     | Restart LSP                                 |

### Colors & UI

- Colorscheme: **Catppuccin mocha**
- Statusline: lualine (default)
- Indent guides: mini.indentscope (animated vertical line)
- Autopairs: nvim-autopairs (auto-close `() [] {}` etc.)

### Other Included Plugins

| Plugin                          | Purpose / Keymaps                          |
|---------------------------------|--------------------------------------------|
| **telescope-fzf-native.nvim**   | Faster Telescope sorting (no manual keys)   |
| **which-key.nvim**              | `<Space>?` shows leader menu               |
| **gitsigns.nvim**               | Git hunks in gutter; `<leader>hp` preview, etc. (see which-key) |
| **todo-comments.nvim**          | Highlights TODO/FIXME; `<leader>ft` search |
| **Comment.nvim**                | `gcc` line comment, `gc` visual; supports Treesitter |
| **nvim-autopairs**              | Auto-closes pairs; works in insert mode    |
| **mini.indentscope**            | Visual indent guide (animated)             |

### Management Commands

| Command        | Description                                      |
|----------------|--------------------------------------------------|
| `:Lazy`        | Open plugin manager                              |
| `:Mason`       | Install/manage LSP servers, formatters, linters  |
| `:checkhealth` | Verify Neovim and plugin health                  |

Enjoy your powerful, AI-crafted Neovim setup! 🚀
```

You can copy this entire content into a file named `README.md` in the same directory as your script. It serves both as documentation for the setup script and includes the full keymap cheat sheet for daily reference.