{ config, pkgs, ... }:
{
  # Use nixvim for a declarative Neovim configuration
  programs.nixvim = {
    enable = true;
    
    # Basic options
    opts = {
      number = true;
      relativenumber = true;
      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      smartindent = true;
      wrap = false;
      ignorecase = true;
      smartcase = true;
      hlsearch = false;
      incsearch = true;
      termguicolors = true;
      scrolloff = 8;
      signcolumn = "yes";
      updatetime = 50;
      colorcolumn = "80";
    };
    
    # LazyVim-style key mappings
    globals.mapleader = " ";  # Space as leader key
    globals.maplocalleader = "\\";  # Backslash as local leader
    
    keymaps = [
      # Better up/down
      { mode = ["n" "x"]; key = "j"; action = "v:count == 0 ? 'gj' : 'j'"; options = { expr = true; silent = true; desc = "Down"; }; }
      { mode = ["n" "x"]; key = "k"; action = "v:count == 0 ? 'gk' : 'k'"; options = { expr = true; silent = true; desc = "Up"; }; }
      
      # Move to window using the <ctrl> hjkl keys
      { mode = "n"; key = "<C-h>"; action = "<C-w>h"; options.desc = "Go to left window"; }
      { mode = "n"; key = "<C-j>"; action = "<C-w>j"; options.desc = "Go to lower window"; }
      { mode = "n"; key = "<C-k>"; action = "<C-w>k"; options.desc = "Go to upper window"; }
      { mode = "n"; key = "<C-l>"; action = "<C-w>l"; options.desc = "Go to right window"; }
      
      # Resize window using <ctrl> arrow keys
      { mode = "n"; key = "<C-Up>"; action = "<cmd>resize +2<cr>"; options.desc = "Increase window height"; }
      { mode = "n"; key = "<C-Down>"; action = "<cmd>resize -2<cr>"; options.desc = "Decrease window height"; }
      { mode = "n"; key = "<C-Left>"; action = "<cmd>vertical resize -2<cr>"; options.desc = "Decrease window width"; }
      { mode = "n"; key = "<C-Right>"; action = "<cmd>vertical resize +2<cr>"; options.desc = "Increase window width"; }
      
      # Move Lines
      { mode = "n"; key = "<A-j>"; action = "<cmd>m .+1<cr>=="; options.desc = "Move line down"; }
      { mode = "n"; key = "<A-k>"; action = "<cmd>m .-2<cr>=="; options.desc = "Move line up"; }
      { mode = "i"; key = "<A-j>"; action = "<esc><cmd>m .+1<cr>==gi"; options.desc = "Move line down"; }
      { mode = "i"; key = "<A-k>"; action = "<esc><cmd>m .-2<cr>==gi"; options.desc = "Move line up"; }
      { mode = "v"; key = "<A-j>"; action = ":m '>+1<cr>gv=gv"; options.desc = "Move line down"; }
      { mode = "v"; key = "<A-k>"; action = ":m '<-2<cr>gv=gv"; options.desc = "Move line up"; }
      
      # Buffer management
      { mode = "n"; key = "<S-h>"; action = "<cmd>bprevious<cr>"; options.desc = "Prev buffer"; }
      { mode = "n"; key = "<S-l>"; action = "<cmd>bnext<cr>"; options.desc = "Next buffer"; }
      { mode = "n"; key = "[b"; action = "<cmd>bprevious<cr>"; options.desc = "Prev buffer"; }
      { mode = "n"; key = "]b"; action = "<cmd>bnext<cr>"; options.desc = "Next buffer"; }
      { mode = "n"; key = "<leader>bb"; action = "<cmd>e #<cr>"; options.desc = "Switch to Other Buffer"; }
      { mode = "n"; key = "<leader>`"; action = "<cmd>e #<cr>"; options.desc = "Switch to Other Buffer"; }
      { mode = "n"; key = "<leader>bd"; action = "<cmd>bdelete<cr>"; options.desc = "Delete Buffer"; }
      { mode = "n"; key = "<leader>b["; action = "<cmd>bprevious<cr>"; options.desc = "Previous Buffer"; }
      { mode = "n"; key = "<leader>b]"; action = "<cmd>bnext<cr>"; options.desc = "Next Buffer"; }
      
      # Clear search with <esc>
      { mode = ["i" "n"]; key = "<esc>"; action = "<cmd>noh<cr><esc>"; options.desc = "Escape and clear hlsearch"; }
      
      # Save file
      { mode = ["i" "x" "n" "s"]; key = "<C-s>"; action = "<cmd>w<cr><esc>"; options.desc = "Save file"; }
      
      # Better indenting
      { mode = "v"; key = "<"; action = "<gv"; }
      { mode = "v"; key = ">"; action = ">gv"; }
      
      # Lazy
      { mode = "n"; key = "<leader>l"; action = "<cmd>Lazy<cr>"; options.desc = "Lazy"; }
      
      # New file
      { mode = "n"; key = "<leader>fn"; action = "<cmd>enew<cr>"; options.desc = "New File"; }
      
      # Location/quickfix lists
      { mode = "n"; key = "<leader>xl"; action = "<cmd>lopen<cr>"; options.desc = "Location List"; }
      { mode = "n"; key = "<leader>xq"; action = "<cmd>copen<cr>"; options.desc = "Quickfix List"; }
      
      # Quit
      { mode = "n"; key = "<leader>qq"; action = "<cmd>qa<cr>"; options.desc = "Quit all"; }
      
      # Windows
      { mode = "n"; key = "<leader>ww"; action = "<C-W>p"; options.desc = "Other window"; }
      { mode = "n"; key = "<leader>wd"; action = "<C-W>c"; options.desc = "Delete window"; }
      { mode = "n"; key = "<leader>w-"; action = "<C-W>s"; options.desc = "Split window below"; }
      { mode = "n"; key = "<leader>w|"; action = "<C-W>v"; options.desc = "Split window right"; }
      { mode = "n"; key = "<leader>-"; action = "<C-W>s"; options.desc = "Split window below"; }
      { mode = "n"; key = "<leader>|"; action = "<C-W>v"; options.desc = "Split window right"; }
      
      # Tabs
      { mode = "n"; key = "<leader><tab>l"; action = "<cmd>tablast<cr>"; options.desc = "Last Tab"; }
      { mode = "n"; key = "<leader><tab>f"; action = "<cmd>tabfirst<cr>"; options.desc = "First Tab"; }
      { mode = "n"; key = "<leader><tab><tab>"; action = "<cmd>tabnew<cr>"; options.desc = "New Tab"; }
      { mode = "n"; key = "<leader><tab>]"; action = "<cmd>tabnext<cr>"; options.desc = "Next Tab"; }
      { mode = "n"; key = "<leader><tab>d"; action = "<cmd>tabclose<cr>"; options.desc = "Close Tab"; }
      { mode = "n"; key = "<leader><tab>["; action = "<cmd>tabprevious<cr>"; options.desc = "Previous Tab"; }
      
      # Plugin-specific keymaps
      # File explorer
      { mode = "n"; key = "<leader>e"; action = "<cmd>Neotree toggle<cr>"; options.desc = "Explorer NeoTree (root dir)"; }
      { mode = "n"; key = "<leader>E"; action = "<cmd>Neotree toggle float<cr>"; options.desc = "Explorer NeoTree (float)"; }
      
      # Search/Find
      { mode = "n"; key = "<leader>ff"; action = "<cmd>FzfLua files<cr>"; options.desc = "Find Files (root dir)"; }
      { mode = "n"; key = "<leader>fF"; action = "<cmd>FzfLua files cwd=%:p:h<cr>"; options.desc = "Find Files (cwd)"; }
      { mode = "n"; key = "<leader>fg"; action = "<cmd>FzfLua live_grep<cr>"; options.desc = "Grep (root dir)"; }
      { mode = "n"; key = "<leader>fG"; action = "<cmd>FzfLua live_grep cwd=%:p:h<cr>"; options.desc = "Grep (cwd)"; }
      { mode = "n"; key = "<leader>/"; action = "<cmd>FzfLua live_grep<cr>"; options.desc = "Grep (root dir)"; }
      { mode = "n"; key = "<leader>fb"; action = "<cmd>FzfLua buffers<cr>"; options.desc = "Buffers"; }
      { mode = "n"; key = "<leader>fr"; action = "<cmd>FzfLua oldfiles<cr>"; options.desc = "Recent"; }
      { mode = "n"; key = "<leader>fc"; action = "<cmd>FzfLua commands<cr>"; options.desc = "Commands"; }
      { mode = "n"; key = "<leader>fh"; action = "<cmd>FzfLua help_tags<cr>"; options.desc = "Help Pages"; }
      { mode = "n"; key = "<leader>fk"; action = "<cmd>FzfLua keymaps<cr>"; options.desc = "Key Maps"; }
      { mode = "n"; key = "<leader>fR"; action = "<cmd>FzfLua resume<cr>"; options.desc = "Resume"; }
      
      # Git
      { mode = "n"; key = "<leader>gg"; action = "<cmd>FzfLua git_status<cr>"; options.desc = "Git Status"; }
      { mode = "n"; key = "<leader>gb"; action = "<cmd>FzfLua git_branches<cr>"; options.desc = "Git Branches"; }
      { mode = "n"; key = "<leader>gc"; action = "<cmd>FzfLua git_commits<cr>"; options.desc = "Git Commits"; }
      
      # LSP
      { mode = "n"; key = "gd"; action = "<cmd>FzfLua lsp_definitions<cr>"; options.desc = "Goto Definition"; }
      { mode = "n"; key = "gr"; action = "<cmd>FzfLua lsp_references<cr>"; options.desc = "References"; }
      { mode = "n"; key = "gI"; action = "<cmd>FzfLua lsp_implementations<cr>"; options.desc = "Goto Implementation"; }
      { mode = "n"; key = "gy"; action = "<cmd>FzfLua lsp_typedefs<cr>"; options.desc = "Goto T[y]pe Definition"; }
      { mode = "n"; key = "gD"; action = "<cmd>lua vim.lsp.buf.declaration()<cr>"; options.desc = "Goto Declaration"; }
      { mode = "n"; key = "K"; action = "<cmd>lua vim.lsp.buf.hover()<cr>"; options.desc = "Hover"; }
      { mode = "n"; key = "gK"; action = "<cmd>lua vim.lsp.buf.signature_help()<cr>"; options.desc = "Signature Help"; }
      { mode = "i"; key = "<c-k>"; action = "<cmd>lua vim.lsp.buf.signature_help()<cr>"; options.desc = "Signature Help"; }
      { mode = ["n" "v"]; key = "<leader>ca"; action = "<cmd>lua vim.lsp.buf.code_action()<cr>"; options.desc = "Code Action"; }
      { mode = "n"; key = "<leader>cA"; action = "<cmd>FzfLua lsp_code_actions<cr>"; options.desc = "Source Action"; }
      { mode = "n"; key = "<leader>cr"; action = "<cmd>lua vim.lsp.buf.rename()<cr>"; options.desc = "Rename"; }
      
      # Diagnostics
      { mode = "n"; key = "<leader>xx"; action = "<cmd>TroubleToggle<cr>"; options.desc = "Document Diagnostics (Trouble)"; }
      { mode = "n"; key = "<leader>xX"; action = "<cmd>TroubleToggle workspace_diagnostics<cr>"; options.desc = "Workspace Diagnostics (Trouble)"; }
      { mode = "n"; key = "<leader>xL"; action = "<cmd>TroubleToggle loclist<cr>"; options.desc = "Location List (Trouble)"; }
      { mode = "n"; key = "<leader>xQ"; action = "<cmd>TroubleToggle quickfix<cr>"; options.desc = "Quickfix List (Trouble)"; }
      { mode = "n"; key = "[d"; action = "<cmd>lua vim.diagnostic.goto_prev()<cr>"; options.desc = "Prev Diagnostic"; }
      { mode = "n"; key = "]d"; action = "<cmd>lua vim.diagnostic.goto_next()<cr>"; options.desc = "Next Diagnostic"; }
      { mode = "n"; key = "[e"; action = "<cmd>lua vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.ERROR})<cr>"; options.desc = "Prev Error"; }
      { mode = "n"; key = "]e"; action = "<cmd>lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.ERROR})<cr>"; options.desc = "Next Error"; }
      { mode = "n"; key = "[w"; action = "<cmd>lua vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.WARN})<cr>"; options.desc = "Prev Warning"; }
      { mode = "n"; key = "]w"; action = "<cmd>lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.WARN})<cr>"; options.desc = "Next Warning"; }
      
      # Flash (jump to word)
      { mode = ["n" "x" "o"]; key = "s"; action = "<cmd>lua require('flash').jump()<cr>"; options.desc = "Flash"; }
      { mode = ["n" "x" "o"]; key = "S"; action = "<cmd>lua require('flash').treesitter()<cr>"; options.desc = "Flash Treesitter"; }
      { mode = "o"; key = "r"; action = "<cmd>lua require('flash').remote()<cr>"; options.desc = "Remote Flash"; }
      { mode = ["x" "o"]; key = "R"; action = "<cmd>lua require('flash').treesitter_search()<cr>"; options.desc = "Treesitter Search"; }
      { mode = "c"; key = "<c-s>"; action = "<cmd>lua require('flash').toggle()<cr>"; options.desc = "Toggle Flash Search"; }
      
      # Todo Comments
      { mode = "n"; key = "]t"; action = "<cmd>lua require('todo-comments').jump_next()<cr>"; options.desc = "Next todo comment"; }
      { mode = "n"; key = "[t"; action = "<cmd>lua require('todo-comments').jump_prev()<cr>"; options.desc = "Previous todo comment"; }
      { mode = "n"; key = "<leader>xt"; action = "<cmd>TodoTrouble<cr>"; options.desc = "Todo (Trouble)"; }
      { mode = "n"; key = "<leader>xT"; action = "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>"; options.desc = "Todo/Fix/Fixme (Trouble)"; }
      { mode = "n"; key = "<leader>st"; action = "<cmd>TodoFzfLua<cr>"; options.desc = "Todo"; }
      { mode = "n"; key = "<leader>sT"; action = "<cmd>TodoFzfLua keywords=TODO,FIX,FIXME<cr>"; options.desc = "Todo/Fix/Fixme"; }
    ];
    
    # Colorschemes managed by Stylix
    
    # Plugins
    plugins = {
      # Core functionality
      lazy.enable = true;
      
      # UI enhancements
      lualine = {
        enable = true;
        settings.options.theme = "auto";  # Use Stylix theme
      };
      
      bufferline.enable = true;
      which-key.enable = true;
      
      # File management
      neo-tree = {
        enable = true;
      };
      
      # Git integration
      gitsigns.enable = true;
      
      # Search and navigation
      fzf-lua.enable = true;
      flash.enable = true;
      noice.enable = true;
      
      # LSP and completion
      lsp = {
        enable = true;
        servers = {
          lua_ls.enable = true;
          marksman.enable = true;
          rust_analyzer = {
            enable = true;
            installCargo = false;  # Already installed via home.nix
            installRustc = false;  # Already installed via home.nix
          };
          pyright.enable = true;
          ts_ls.enable = true;
          yamlls.enable = true;
        };
      };
      
      # Completion
      cmp = {
        enable = true;
        settings = {
          sources = [
            { name = "nvim_lsp"; }
            { name = "buffer"; }
            { name = "path"; }
            { name = "luasnip"; }
          ];
        };
      };
      
      # Treesitter (nixvim handles compatibility automatically)
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
          ensure_installed = [
            "lua"
            "vim" 
            "vimdoc"
            "markdown"
            "markdown_inline"
            "python"
            "rust"
            "typescript"
            "javascript"
            "yaml"
            "toml"
          ];
        };
      };
      
      # Additional plugins
      trouble.enable = true;
      todo-comments.enable = true;
      persistence.enable = true;
    };
    
    # Extra plugins - all the packages needed for nixvim plugins
    extraPlugins = with pkgs.vimPlugins; [
      # Custom plugins
      rainbow_parentheses-vim
      markdown-preview-nvim
      lsp-colors-nvim
      
      # Nixvim plugin packages
      tokyonight-nvim
      lualine-nvim
      bufferline-nvim
      which-key-nvim
      neo-tree-nvim
      gitsigns-nvim
      fzf-lua
      flash-nvim
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      luasnip
      cmp_luasnip
      nvim-treesitter
      trouble-nvim
      todo-comments-nvim
      persistence-nvim
      
      # Dependencies
      nui-nvim
      plenary-nvim
    ];
    
    # Extra configuration for custom plugins
    extraConfigLua = ''
      -- Rainbow parentheses configuration
      vim.g["rainbow#max_level"] = 16
      vim.g["rainbow#pairs"] = { { "(", ")" }, { "[", "]" } }
      
      -- Disable Mason since we use Nix for LSP servers
      vim.g.lazyvim_picker = "fzf"
    '';
  };
  
  # Install additional LSP servers and tools via Nix
  home.packages = with pkgs; [
    # Language servers
    lua-language-server
    marksman
    rust-analyzer
    pyright
    typescript-language-server
    yaml-language-server
    
    # Development tools
    ripgrep
    fd
    tree-sitter
    
    # Build tools for Treesitter and plugins
    gcc
    gnumake
    nodejs
    git
  ];
}
