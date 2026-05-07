return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local harpoon = require("harpoon")
    local tmux = require("utils.tmux")

    harpoon:setup({
      cmd = {
        select = function(list_item)
          tmux._sendCommand(list_item.value)
        end,
      },
    })
  end,
  keys = function()
    local harpoon = require("harpoon")
    local tmux = require("utils.tmux")

    return {
      {
        "<leader>ma",
        function()
          harpoon:list():append()
        end,
        desc = "Harpoon file",
      },
      {
        "<leader>mm",
        function()
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = "Harpoon quick menu",
      },
      {
        "<leader>mc",
        function()
          harpoon.ui:toggle_quick_menu(harpoon:list("cmd"), {
            title = "Harpoon cmd menu",
            -- border = "rounded",
            -- title_pos = "center",
          })
        end,
        desc = "harpoon cmd ui toggle_quick_menu",
      },
      {
        "<leader>mq",
        function()
          tmux.clear_all()
        end,
        desc = "clear all tmux windows",
      },
    }
  end,
}
