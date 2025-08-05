return {
  {
    "github/copilot.vim",
    config = function()
      vim.g.copilot_filetypes = {
        ["*"] = true,
        ["copilot-chat"] = false,
      }
      vim.g.copilot_no_tab_map = true -- Disable default tab mapping
      vim.api.nvim_set_keymap(
        "i",
        "<C-j>",
        'copilot#Accept("<CR>")',
        { expr = true, silent = true, noremap = true }
      )
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
    build = "make tiktoken",
    config = function()
      local ui = vim.api.nvim_list_uis()[1]
      local width = 50
      local opts = {
        window = {
          layout = "float",
          width = width,
          height = ui.height - 3,
          row = 2,
          col = math.floor(ui.width * 0.98) - width,
          border = "rounded", -- 'single', 'double', 'rounded', 'solid'
          title = "🤖 AI Assistant",
          zindex = 100, -- Ensure window stays on top
        },

        headers = {
          user = "👤 You: ",
          assistant = "🤖 Copilot: ",
          tool = "🔧 Tool: ",
        },
        separator = "━━",
        show_folds = false, -- Disable folding for cleaner look
      }

      require("CopilotChat").setup(opts)

      vim.api.nvim_set_keymap(
        "n",
        "<leader>C",
        "<cmd>CopilotChatToggle<cr>",
        { noremap = true, silent = true, desc = "AI Chat" }
      )
    end,
  },
  {
    "ggml-org/llama.vim",
    enabled = false,
    init = function()
      vim.g.llama_config = {
        show_info = false,
      }
    end,
  },
  {
    "yetone/avante.nvim",
    enabled = false,
    event = "VeryLazy",
    lazy = true,
    version = false, -- set this to "*" if you want to always pull the latest change, false to update on release
    opts = {
      provider = "ollama",
      providers = {
        ollama = {
          endpoint = "http://localhost:11434",
          -- endpoint = "http://pc.local:11434",
          -- disable_tools = true,
          -- mode = "legacy",
          -- model = "devstral",
          -- model = "qwen2.5-coder:7b",
          -- model = "hf.co/bartowski/Qwen2.5.1-Coder-7B-Instruct-GGUF:Q5_K_S",
          model = "deepseek-coder-v2",
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
    event = "VeryLazy",
    opts = {
      keymaps = {
        accept_suggestion = "<Right>",
        clear_suggestion = "<C-]>",
        accept_word = "<C-j>",
      },
    },
  },
}
