local M = {}

-- cached fcitx command
local fcitx_cmd = nil

local function detect_fcitx()
  if fcitx_cmd ~= nil then
    return fcitx_cmd
  end

  -- check fcitx-remote (fcitx5-remote)
  if vim.fn.executable("fcitx-remote") == 1 then
    fcitx_cmd = "fcitx-remote"
  elseif vim.fn.executable("fcitx5-remote") == 1 then
    fcitx_cmd = "fcitx5-remote"
  else
    fcitx_cmd = false
  end

  return fcitx_cmd
end

local function has_display()
  local os_name = vim.loop.os_uname().sysname
  if os_name ~= "Linux" and os_name ~= "Unix" then
    return true
  end
  return os.getenv("DISPLAY") ~= nil or os.getenv("WAYLAND_DISPLAY") ~= nil
end

function M.setup()
  -- skip if running in SSH
  if os.getenv("SSH_TTY") ~= nil then
    return
  end

  -- skip if no display
  if not has_display() then
    return
  end

  -- skip if fcitx not detected
  local cmd = detect_fcitx()
  if not cmd then
    return
  end

  local _Fcitx2en = function()
    local input_status = tonumber(vim.fn.system(cmd))
    if input_status == 2 then
      vim.b.input_toggle_flag = true
      vim.fn.system(cmd .. " -c")
    end
  end

  local _Fcitx2NonLatin = function()
    if vim.b.input_toggle_flag == nil then
      vim.b.input_toggle_flag = false
    elseif vim.b.input_toggle_flag == true then
      vim.fn.system(cmd .. " -o")
      vim.b.input_toggle_flag = false
    end
  end

  vim.api.nvim_create_augroup("fcitx", { clear = true })
  vim.api.nvim_create_autocmd("InsertEnter", { group = "fcitx", callback = _Fcitx2en })
  vim.api.nvim_create_autocmd("InsertLeave", { group = "fcitx", callback = _Fcitx2en })
  vim.api.nvim_create_autocmd("CmdlineEnter", { group = "fcitx", pattern = "[/\\?]", callback = _Fcitx2en })
  vim.api.nvim_create_autocmd("CmdlineLeave", { group = "fcitx", pattern = "[/\\?]", callback = _Fcitx2NonLatin })
end

return M
