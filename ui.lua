-- jf_looper/ui.lua
local M = {}
local progress = 0

function M.init() end

function M.tick()
  progress = (clock.get_beats() % 16) + clock.get_beat_fraction()
end

local function draw_progress_ring()
  local angle = (progress / 16) * 360
  screen.level(15)
  screen.arc(64, 32, 28, 0, angle)
end

function M.redraw()
  screen.clear()
  draw_progress_ring()
  screen.update()
end

return M
