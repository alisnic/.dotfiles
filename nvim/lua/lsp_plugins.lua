local M = {}

function on_attach_callback(client, _)
  require("lsp_signature").on_attach()

  if client.resolved_capabilities.document_formatting then
    vim.api.nvim_command [[augroup Format]]
    vim.api.nvim_command [[autocmd! * <buffer>]]
    vim.api.nvim_command [[autocmd BufWritePost <buffer> lua vim.lsp.buf.formatting()]]
    vim.api.nvim_command [[augroup END]]
  end

  print "LSP Attached."
end

function M.setup(use)
  use {
    "gfanto/fzf-lsp.nvim",
    config = function()
      local util = require "util"
      util.nmap("<leader>c", ":WorkspaceSymbol<cr>")
      util.nmap("<leader>m", ":DocumentSymbols<cr>")
    end,
  }

  use {
    "folke/trouble.nvim",
    config = function()
      require("trouble").setup {
        icons = false,
        padding = false,
        auto_open = false,
      }

      vim.cmd [[
        augroup packer_trouble
          autocmd!
          autocmd FileType Trouble setlocal wrap
        augroup end
      ]]
    end,
  }

  use {
    "jose-elias-alvarez/null-ls.nvim",
    requires = {
      { "nvim-lua/plenary.nvim" },
    },
    config = function()
      local null_ls = require "null-ls"

      null_ls.setup {
        on_attach = function(client)
          on_attach_callback(client, 1)
        end,
        sources = {
          null_ls.builtins.formatting.prettier.with {
            filetypes = {
              "ruby",
              "typescript",
              "typescriptreact",
              "javascriptreact",
            },
          },
          null_ls.builtins.formatting.stylua.with {
            extra_args = {
              "--config-path",
              vim.fn.expand "~/.config/stylua.toml",
            },
          },
          null_ls.builtins.diagnostics.eslint_d,
          null_ls.builtins.code_actions.eslint_d,
        },
      }
    end,
  }

  use {
    "neovim/nvim-lspconfig",
    requires = {
      { "ray-x/lsp_signature.nvim" },
    },
    config = function()
      local util = require "util"
      util.nmap("k", ":lua vim.lsp.buf.hover()<cr>")
      util.nmap("gd", ":lua vim.lsp.buf.definition()<cr>")
      util.nmap("gi", ":lua vim.lsp.buf.implementation()<cr>")
      util.nmap("gD", ":vsplit<cr>:lua vim.lsp.buf.definition()<cr>")
      util.nmap("gr", ":lua vim.lsp.buf.references()<cr>")
      util.nmap("<leader>ca", ":lua vim.lsp.buf.code_action()<cr>")
      util.nmap("<leader>cr", ":lua vim.lsp.buf.rename()<cr>")

      local capabilities = require("cmp_nvim_lsp").update_capabilities(
        vim.lsp.protocol.make_client_capabilities()
      )

      local servers = { "rust_analyzer", "prismals" }
      for _, lsp in pairs(servers) do
        require("lspconfig")[lsp].setup {
          capabilities = capabilities,
          on_attach = on_attach_callback,
        }
      end

      require("lspconfig").html.setup {
        capabilities = capabilities,
        filetypes = { "html", "eruby" },
        on_attach = function(client, bufnr)
          capabilities.textDocument.completion.completionItem.snippetSupport =
            true

          if vim.bo.filetype == "eruby" then
            client.resolved_capabilities.document_formatting = false
            client.resolved_capabilities.document_range_formatting = false
          end

          on_attach_callback(client, bufnr)
        end,
      }

      local runtime_path = vim.split(package.path, ";")
      table.insert(runtime_path, "lua/?.lua")
      table.insert(runtime_path, "lua/?/init.lua")

      require("lspconfig").sumneko_lua.setup {
        capabilities = capabilities,
        flags = {
          debounce_text_changes = 200,
        },
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT",
              path = runtime_path,
            },
            diagnostics = {
              globals = { "vim", "hs" },
              disable = { "lowercase-global" },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
            },
            telemetry = {
              enable = false,
            },
          },
        },
        on_attach = function(client, bufnr)
          client.resolved_capabilities.document_formatting = false
          client.resolved_capabilities.document_range_formatting = false
          on_attach_callback(client, bufnr)
        end,
      }

      require("lspconfig")["solargraph"].setup {
        capabilities = capabilities,
        -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#solargraph
        settings = {
          solargraph = {
            formatting = false,
            diagnostics = false,
            useBundler = false,
            folding = true,
          },
        },
        on_attach = function(client, bufnr)
          client.resolved_capabilities.document_formatting = false
          client.resolved_capabilities.document_range_formatting = false
          on_attach_callback(client, bufnr)
        end,
      }

      require("lspconfig").tsserver.setup {
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          client.resolved_capabilities.document_formatting = false
          client.resolved_capabilities.document_range_formatting = false
          on_attach_callback(client, bufnr)
        end,
      }

      require("lspconfig").yamlls.setup {
        capabilities = capabilities,
        on_attach = on_attach_callback,
        settings = {
          yaml = {
            schemas = {
              kubernetes = "/*.k8s.yaml",
            },
          },
        },
      }
    end,
  }

  use {
    "RishabhRD/nvim-lsputils",
    requires = {
      { "RishabhRD/popfix" },
    },
    config = function()
      -- vim.lsp.handlers['workspace/symbol'] = require('lsputil.symbols').workspace_handler
      vim.lsp.handlers["textDocument/codeAction"] = require(
        "lsputil.codeAction"
      ).code_action_handler
      -- vim.lsp.handlers['textDocument/codeAction'] = function(_, _, actions)
      --   require('lsputil.codeAction').code_action_handler(nil, actions, nil, nil, nil)
      -- end
    end,
  }
end

return M