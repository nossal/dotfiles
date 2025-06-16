return {
  {
    "ggml-org/llama.vim",
    init = function()
      vim.g.llama_config = {
        show_info = false,
      }
    end,
  },
  {
    "yetone/avante.nvim",
    -- enabled = false,
    event = "VeryLazy",
    lazy = true,
    version = false, -- set this to "*" if you want to always pull the latest change, false to update on release
    opts = {
      provider = "ollama",
      providers = {
        ollama = {
          endpoint = "http://localhost:11434",
          -- disable_tools = true,
          -- mode = "legacy",
          model = "devstral",
          -- model = "qwen2.5-coder:7b",
          -- model = "hf.co/bartowski/Qwen2.5.1-Coder-7B-Instruct-GGUF:Q5_K_S",
          -- model = "deepseek-coder-v2",
        },
      },
      selector = {
        provider = "fzf_lua",
      },
      -- system_prompt = function()
      --   local hub = require("mcphub").get_hub_instance()
      --   return hub and hub:get_active_servers_prompt() or ""
      -- end,
      -- Using function prevents requiring mcphub before it's loaded
      -- custom_tools = function()
      --   return {
      --     require("mcphub.extensions.avante").mcp_tool(),
      --   }
      -- end,
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      -- {
      --   "ravitemer/mcphub.nvim",
      --   dependencies = {
      --     "nvim-lua/plenary.nvim",
      --   },
      --   build = "npm install -g mcp-hub@latest", -- Installs `mcp-hub` node binary globally
      --   config = function()
      --     require("mcphub").setup({
      --       extensions = {
      --         avante = {
      --           make_slash_commands = true, -- make /slash commands from MCP server prompts
      --         },
      --       },
      --     })
      --   end,
      -- },
      -- {
      --   -- support for image pasting
      --   "HakonHarnes/img-clip.nvim",
      --   event = "VeryLazy",
      --   opts = {
      --     -- recommended settings
      --     default = {
      --       embed_image_as_base64 = false,
      --       prompt_for_file_name = false,
      --       drag_and_drop = {
      --         insert_mode = true,
      --       },
      --       -- required for Windows users
      --       use_absolute_path = true,
      --     },
      --   },
      -- },
    },
  },
  {
    "supermaven-inc/supermaven-nvim",
    enabled = false,
    config = function()
      require("supermaven-nvim").setup({})
    end,
    opts = {
      disable_inline_completion = true, -- disables inline completion for use with cmp
      disable_keymaps = true, -- disables built in keymaps for more manual control
    },
  },
}
