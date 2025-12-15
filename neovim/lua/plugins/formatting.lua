return {
  {
    "stevearc/conform.nvim",
    lazy = true,
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        -- Customize or remove this keymap to your liking
        "<leader>gf",
        function()
          require("conform").format({ async = true }, function(err)
            if not err then
              local mode = vim.api.nvim_get_mode().mode
              if vim.startswith(string.lower(mode), "v") then
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
              end
            end
          end)
        end,
        mode = "",
        desc = "Format Code",
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "biome" },
        typescript = { "biome" },
        svelte = { "biome" },
        json = { "biome" },
        css = { "biome" },
        yaml = { "yamlfmt" },
        python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
        java = { "lsp" },
        bash = { "shfmt" },
        sh = { "shfmt" },
        shell = { "shfmt" },
        zsh = { "shfmt" },
        rust = { "rustfmt" },
        html = { "superhtml", lsp_format = "fallback" },
        xml = { "xmlformat", lsp_format = "fallback" },
        ocaml = { "ocamlformat" },
      },
      formatters = {
        biome = {
          args = { "format", "--config-path", vim.fn.expand("$HOME/.dotfiles"), "--stdin-file-path", "$FILENAME" },
        },
      },
    },
    init = function()
      -- If you want the formatexpr, here is the place to set it
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },
}
