{pkgs, ...}: {
  config = {
    opts.completeopt = ["menu" "menuone" "noselect"];

    plugins = {
      luasnip.enable = true;

      lspkind = {
        enable = true;

        cmp = {
          enable = true;
          menu = {
            nvim_lsp = "[LSP]";
            nvim_lua = "[api]";
            path = "[path]";
            luasnip = "[snip]";
            buffer = "[buffer]";
            neorg = "[neorg]";
            vim-dadbod-completion = "[DB]";
          };
        };
      };

      cmp = {
        enable = true;

        settings = {
          mapping = {
            __raw = ''
              cmp.mapping.preset.insert({
                ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                ['<C-d>'] = cmp.mapping.scroll_docs(4),
                ['<C-e>'] = cmp.mapping(function()
                                if cmp.visible() then
                                    cmp.select_prev_item({behavior = cmp.SelectBehavior.Select})
                                else
                                    cmp.complete()
                                end
                            end),
                ['<C-n>'] = cmp.mapping(function()
                                if cmp.visible() then
                                    cmp.select_next_item({behavior = cmp.SelectBehavior.Select})
                                else
                                    cmp.complete()
                                end
                            end),
                ['<C-a>'] = cmp.mapping.confirm({ select = true }),
              })
            '';
          };
          snippet = {
            expand = "function(args) require('luasnip').lsp_expand(args.body) end";
          };

          sources = [
            {name = "path";}
            {name = "nvim_lsp";}
            {name = "luasnip";}
            {
              name = "buffer";
              # Words from other open buffers can also be suggested.
              option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
            }
            {name = "neorg";}
            {name = "vim-dadbod-completion";}
          ];
        };
      };
    };
    extraPlugins = [pkgs.vimPlugins.cmp-cmdline];
    extraConfigLua = ''
      local cmp = require("cmp")

      -- cmp.setup.filetype('gitcommit', {
      --     sources = cmp.config.sources({
      --         { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
      --     }, {
      --         { name = 'buffer' },
      --     })
      -- })

      -- NOTE: this needs to be in sync with the nix config so that it works on cmdline and search
      local completion_mappings = {
          ["<C-u>"] = cmp.mapping.scroll_docs(-4);
          ["<C-d>"] = cmp.mapping.scroll_docs(4);
          ["<C-e>"] = { c = function()
              if cmp.visible() then
                    cmp.select_prev_item({behavior = cmp.SelectBehavior.Select})
                else
                    cmp.complete()
                end
            end},
          ["<C-n>"] = { c = function()
              if cmp.visible() then
                  cmp.select_next_item({behavior = cmp.SelectBehavior.Select})
              else
                  cmp.complete()
              end
              end},
            ["<C-a>"] = { c = cmp.mapping.confirm({ select = true }) },
          }

      cmp.setup.cmdline({ '/', '?' }, {
          mapping = completion_mappings,
          sources = {
              { name = 'buffer' }
          }
      })

        cmp.setup.cmdline(':', {
            mapping = completion_mappings,
            sources = cmp.config.sources({
                { name = 'path' }
            }, {
                { name = 'cmdline' }
            })
        })

    '';
  };
}
