local utils = require("utils")

local headers = require("utils.headers")

local M = {}

local function neovimHeader(dashboard)
  vim.api.nvim_set_hl(0, "AlphaNeovimLogoBlue", { fg = "#2377A8" })
  vim.api.nvim_set_hl(0, "AlphaNeovimLogoGreen", { fg = "#2D882D" })
  vim.api.nvim_set_hl(0, "AlphaNeovimLogoGreenFBlueB", { fg = "#2D882D", bg = "#2377A8" })

  local logo = {
    [[ ███       ███ ]],
    [[████      ████]],
    [[██████     █████]],
    [[███████    █████]],
    [[████████   █████]],
    [[█████████  █████]],
    [[█████ ████ █████]],
    [[█████  █████████]],
    [[█████   ████████]],
    [[█████    ███████]],
    [[█████     ██████]],
    [[████      ████]],
    [[ ███       ███ ]],
    [[                  ]],
    [[ N  E  O  V  I  M ]],
  }

  dashboard.opts.layout[1].val = 6
  dashboard.section.header.val = logo
  dashboard.section.header.opts.hl = {
    {
      { "AlphaNeovimLogoBlue", 0, 0 },
      { "AlphaNeovimLogoGreen", 1, 14 },
      { "AlphaNeovimLogoBlue", 23, 34 },
    },
    {
      { "AlphaNeovimLogoBlue", 0, 2 },
      { "AlphaNeovimLogoGreenFBlueB", 2, 4 },
      { "AlphaNeovimLogoGreen", 4, 19 },
      { "AlphaNeovimLogoBlue", 27, 40 },
    },
    {
      { "AlphaNeovimLogoBlue", 0, 4 },
      { "AlphaNeovimLogoGreenFBlueB", 4, 7 },
      { "AlphaNeovimLogoGreen", 7, 22 },
      { "AlphaNeovimLogoBlue", 29, 42 },
    },
    {
      { "AlphaNeovimLogoBlue", 0, 8 },
      { "AlphaNeovimLogoGreenFBlueB", 8, 10 },
      { "AlphaNeovimLogoGreen", 10, 25 },
      { "AlphaNeovimLogoBlue", 31, 44 },
    },
    {
      { "AlphaNeovimLogoBlue", 0, 10 },
      { "AlphaNeovimLogoGreenFBlueB", 10, 13 },
      { "AlphaNeovimLogoGreen", 13, 28 },
      { "AlphaNeovimLogoBlue", 33, 46 },
    },
    {
      { "AlphaNeovimLogoBlue", 0, 13 },
      { "AlphaNeovimLogoGreen", 14, 31 },
      { "AlphaNeovimLogoBlue", 35, 49 },
    },
    {
      { "AlphaNeovimLogoBlue", 0, 13 },
      { "AlphaNeovimLogoGreen", 16, 32 },
      { "AlphaNeovimLogoBlue", 35, 49 },
    },
    {
      { "AlphaNeovimLogoBlue", 0, 13 },
      { "AlphaNeovimLogoGreen", 17, 33 },
      { "AlphaNeovimLogoBlue", 35, 49 },
    },
    {
      { "AlphaNeovimLogoBlue", 0, 13 },
      { "AlphaNeovimLogoGreen", 18, 34 },
      { "AlphaNeovimLogoGreenFBlueB", 33, 35 },
      { "AlphaNeovimLogoBlue", 35, 49 },
    },
    {
      { "AlphaNeovimLogoBlue", 0, 13 },
      { "AlphaNeovimLogoGreen", 19, 35 },
      { "AlphaNeovimLogoGreenFBlueB", 34, 35 },
      { "AlphaNeovimLogoBlue", 35, 49 },
    },
    {
      { "AlphaNeovimLogoBlue", 0, 13 },
      { "AlphaNeovimLogoGreen", 20, 36 },
      { "AlphaNeovimLogoGreenFBlueB", 35, 37 },
      { "AlphaNeovimLogoBlue", 37, 49 },
    },
    {
      { "AlphaNeovimLogoBlue", 0, 13 },
      { "AlphaNeovimLogoGreen", 21, 37 },
      { "AlphaNeovimLogoGreenFBlueB", 36, 37 },
      { "AlphaNeovimLogoBlue", 37, 49 },
    },
    {
      { "AlphaNeovimLogoBlue", 1, 13 },
      { "AlphaNeovimLogoGreen", 20, 35 },
      { "AlphaNeovimLogoBlue", 37, 48 },
    },
    {},
    { { "AlphaNeovimLogoGreen", 0, 9 }, { "AlphaNeovimLogoBlue", 9, 18 } },
  }
end

local function lineColor(lines)
  local out = {}
  local colors = utils.generateGradientColors(#lines)
  local dashboardHighlight = "AlphaDashboardHeader"
  for i, line in ipairs(lines) do
    vim.api.nvim_set_hl(0, dashboardHighlight .. i, { fg = colors[i] })
    local hi = dashboardHighlight .. i
    table.insert(out, { hi = hi, line = line })
  end
  return out
end

-- Map over the headers, setting a different color for each line.
-- This is done by setting the Highligh to StartLogoN, where N is the row index.
-- Define AlphaDashboardHeader1..AlphaDashboardHeaderN to get a nice gradient.
local function header_color(header_chars)
  local lines = {}
  for _, lineConfig in pairs(header_chars) do
    local hi = lineConfig.hi
    local line_chars = lineConfig.line
    local line = {
      type = "text",
      val = line_chars,
      opts = {
        hl = hi,
        shrink_margin = false,
        position = "center",
      },
    }
    table.insert(lines, line)
  end
  local top = lines[1].val.top
  -- 去掉第一行
  if top then
    lines = vim.list_slice(lines, 2)
  else
    top = 8
  end
  local output = {
    type = "group",
    val = lines,
    opts = { position = "center", top = top },
  }

  return output
end

local function randomHeader(dashboard, header)
  if not header then
    -- header = header_color(lineColor(headers[math.random(#headers)]))
    header = header_color(lineColor(headers[math.random(13, 14)]))
  end
  dashboard.section.header.opts.position = header.opts.position
  dashboard.section.header.type = header.type
  dashboard.section.header.val = header.val
  dashboard.opts.layout[1].val = header.opts.top
end

local life_progress_bar = utils.life_progress_bar
local function LifeProgressHeader(dashboard)
  local lines = {
    -- [[𝖑𝖎𝖋𝖊 𝖕𝖗𝖔𝖌𝖗𝖊𝖘𝖘]],
    -- "l̊i̊f̊e̊ ̊p̊r̊o̊g̊r̊e̊s̊s̊",
    "𝓵𝓲𝓯𝓮 𝓹𝓻𝓸𝓰𝓻𝓮𝓼𝓼",
    -- [[▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄]],
    -- [[█ ███▄██ ▄▄█ ▄▄███▀▄▄▀█ ▄▄▀█▀▄▄▀█ ▄▄▄█ ▄▄▀█ ▄▄█ ▄▄█ ▄▄]],
    -- [[█ ███ ▄█ ▄██ ▄▄███ ▀▀ █ ▀▀▄█ ██ █ █▄▀█ ▀▀▄█ ▄▄█▄▄▀█▄▄▀]],
    -- [[█▄▄█▄▄▄█▄███▄▄▄███ ████▄█▄▄██▄▄██▄▄▄▄█▄█▄▄█▄▄▄█▄▄▄█▄▄▄]],
    -- [[▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀]],
    -- [[108,105,102,101,32,112,114,111,103,114,101,115,115]],
    life_progress_bar(2022, "👶"),
    life_progress_bar(1992, "👰"),
    life_progress_bar(1990, "🤵"),
    life_progress_bar(1957, "👵"),
    life_progress_bar(1955, "👴"),
  }
  local header = header_color(lineColor(lines))
  randomHeader(dashboard, header)
end

function M.setHeaders(dashboard, type)
  local fns = {
    -- neovimHeader,
    randomHeader,
    -- LifeProgressHeader,
  }
  local fn = randomHeader
  if type == "neovim" then
    fn = neovimHeader
  elseif type == "life" then
    fn = LifeProgressHeader
  else
    fn = fns[math.random(#fns)]
  end
  fn(dashboard)
end

return M
