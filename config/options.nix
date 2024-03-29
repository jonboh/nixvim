{
  config = {
    globals = {
      # Disable useless providers
      loaded_ruby_provider = 0; # Ruby
      loaded_perl_provider = 0; # Perl
      loaded_python_provider = 0; # Python 2
    };

    options = {
      number = true;
      relativenumber = true;
      cursorline = true;

      errorbells = true;

      tabstop = 4;
      softtabstop = 4;
      shiftwidth = 4;
      expandtab = true;
      smartindent = true;
      wrap = false;

      # navigation
      scrolloff = 8;

      # search
      hlsearch = true;
      incsearch = true;
      ignorecase = true;
      smartcase = true;

      # other
      colorcolumn = [80 100];
      signcolumn = "yes";
      termguicolors = true;
      fileformat = "unix";
      ff = "unix";
      winbar = "%f %m";
      conceallevel = 2;

      # history and backup
      updatetime = 100;
      swapfile = false;
      backup = false;
      undofile = true;

      # folding
      foldmethod = "expr";
      foldexpr = "nvim_treesitter#foldexpr()";
      foldminlines = 3;
      foldenable = true;
      foldlevelstart = 9;

      # leader
      timeout = true;
      timeoutlen = 500;

      # grep
      grepprg = "rg --vimgrep";

      cmdheight = 0;
    };
    # extraConfigLua = ''
    #   vim.opt.shortmess:append("S")
    #   vim.opt.shortmess:append("C")
    #   vim.opt.shortmess:append("s")
    #   vim.opt.shortmess:append("c")
    # '';
  };
}
