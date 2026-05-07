local M = {}

---@param url string
function M.open_browser(url)
  vim.cmd("silent !$BROWSER " .. vim.fn.shellescape(url))
end

---@param text string
---@param regx string
function M.get_match_content(text, regx, index)
  if not index then
    index = 1
  end

  if not regx then
    return text
  end

  local startIndex, endIndex = string.find(text, regx)
  if not startIndex then
    return
  end

  text = string.sub(text, startIndex + index, endIndex - index)
  return text
end

function M.get_current_line_match_content(regx)
  local curLine = vim.api.nvim_get_current_line()
  return M.get_match_content(curLine, regx)
end

function M.open_nvim_plugin_git_repo()
  local pluginName = M.get_current_line_match_content('".*"')
  if not pluginName then
    return
  end
  M.open_github_repo(pluginName)
end

function M.open_github_repo(path)
  M.open_browser([[https://github.com/]] .. path)
end

function M.match_line_url(cb)
  local curLine = vim.api.nvim_get_current_line()
  local url = M.get_match_content(curLine, 'http?s://[^ ^)^%]^"]*', 0)

  if url ~= nil then
    cb(url)
  end
end

function M.print_current_var(type)
  local filetype = vim.bo.filetype
  local cword = vim.fn.expand("<cword>")

  if type ~= "cword" then
    cword = M.getVisualSelection()
  end

  if filetype == "lua" then
    vim.cmd("normal o" .. "print(" .. cword .. ")")
  else
    vim.cmd("normal o" .. string.format([[console.log(`%s >>`, %s)]], cword, cword))
  end
end

function M.dump(...)
  local objects = vim.tbl_map(vim.inspect, { ... })
  return unpack(objects)
end

function M.stringify_print(...)
  print(M.dump(...))
end

function M.split_string(str, delimiter)
  local result = {}
  for match in (str .. delimiter):gmatch("(.-)" .. delimiter) do
    table.insert(result, match)
  end
  return result
end

function M.get_os_command_output(cmd, cwd)
  if type(cmd) ~= "table" then
    print("Harpoon: [get_os_command_output]: cmd has to be a table")
    return {}
  end

  local result = vim.system(cmd, { cwd = cwd }):wait()
  local stdout = result.stdout ~= "" and vim.split(result.stdout, "\n") or {}
  local stderr = result.stderr ~= "" and vim.split(result.stderr, "\n") or {}

  return stdout, result.code, stderr
end

function M.getRandomRGB()
  local r = math.random(0, 255)
  local g = math.random(0, 255)
  local b = math.random(0, 255)
  return { r, g, b }
end

function M.generateGradientColors(count)
  if count <= 1 then
    local c = M.getRandomRGB()
    return { string.format("#%02X%02X%02X", c[1], c[2], c[3]) }
  end

  local startColor = M.getRandomRGB()
  local endColor = M.getRandomRGB()

  -- 计算每个颜色分量的渐变步长
  local colors = {}
  local stepR = (endColor[1] - startColor[1]) / (count - 1)
  local stepG = (endColor[2] - startColor[2]) / (count - 1)
  local stepB = (endColor[3] - startColor[3]) / (count - 1)

  for i = 1, count do
    local r = math.floor(startColor[1] + stepR * (i - 1))
    local g = math.floor(startColor[2] + stepG * (i - 1))
    local b = math.floor(startColor[3] + stepB * (i - 1))

    -- 确保颜色值在 0 到 255 之间
    r = math.min(255, math.max(0, r))
    g = math.min(255, math.max(0, g))
    b = math.min(255, math.max(0, b))

    table.insert(colors, string.format("#%02X%02X%02X", r, g, b))
  end
  return colors
end

function M.life_progress_bar(birth_year, point)
  local current_year = os.date("%Y")
  local age = current_year - birth_year
  local average_lifespan = 100
  -- 计算进度条长度
  local bar_length = 50 -- 进度条总长度为80个字符
  local progress = (age / average_lifespan) * bar_length

  local bar = string.rep("━", math.floor(progress))
    .. point
    .. string.rep("━", bar_length - math.floor(progress) - 1)

  local life_progress = math.floor(age / average_lifespan * 100)
  if life_progress < 10 then
    return bar .. "0" .. tostring(life_progress) .. "%"
  end
  return bar .. life_progress .. "%"
end

return M
