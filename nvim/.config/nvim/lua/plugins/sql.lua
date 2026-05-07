return {
  -- 启用 LazyVim SQL extra
  { "LazyVim/LazyVim", import = "lazyvim.plugins.extras.lang.sql" },

  -- DBUI 配置
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
    },
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    init = function()
      -- 数据库连接配置（请根据实际情况修改）
      -- vim.g.dbs = {
      -- 请根据实际情况修改用户名、密码和数据库名
      -- app = "postgres://postgres:postgres@localhost:5432/dekelong",
      -- 示例
      -- dev = "postgres://postgres:password@localhost:5432/dev_db",
      -- local = "sqlite:///home/sean/data/app.db",
      -- }

      -- 保存和临时文件位置
      local data_path = vim.fn.stdpath("state") .. "/dadbod_ui"
      vim.g.db_ui_save_location = data_path
      vim.g.db_ui_tmp_query_location = data_path .. "/tmp"

      -- UI 设置
      vim.g.db_ui_auto_execute_table_helpers = 1
      vim.g.db_ui_show_database_icon = true
      vim.g.db_ui_use_nerd_fonts = true
      vim.g.db_ui_use_nvim_notify = true

      -- 保存时不自动执行查询（避免大查询崩溃）
      vim.g.db_ui_execute_on_save = false
    end,
  },
}
