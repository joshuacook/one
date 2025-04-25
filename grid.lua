-- jf_looper/grid.lua
local util = require("util")
local M = {}

local ROT = {"0","90","180","270"}

local STATE_EMPTY, STATE_ARMED, STATE_REC, STATE_PLAY, STATE_MUTED =
      0,           1,            2,        3,          4

local loops = {}
for v=1,6 do loops[v] = {state=STATE_EMPTY, level=1.0} end

local g

local function phys_to_logical(x,y)
  local r = params:get("grid_rot")
  if     r==1 then return x,y
  elseif r==2 then return 17-y, x
  elseif r==3 then return 17-x, 17-y
  elseif r==4 then return y, 17-x end
end

local last_press = {}

local function set_led(x,y,l) g:led(x,y,l) end

local function redraw()
  g:all(0)
  for v=1,6 do
    local x = v
    for y=1,8 do
      local lvl = (8-y < loops[v].level*8) and 4 or 0
      set_led(x+10,y,lvl) -- fader cols
    end
    local state = loops[v].state
    local led_lvl = ({0,8,12,15,4})[state+1]
    set_led(x,1,led_lvl)
  end
  g:refresh()
end

function M.tick() end

function M.init(grid_conn)
  g = grid_conn
  g.key = function(px,py,z)
    local x,y = phys_to_logical(px,py)
    if x<=6 then
      if z==1 then
        last_press[x] = clock.get_beat_fraction()
      else
        local held = clock.get_beat_fraction() - (last_press[x] or 0)
        if held > 0.2 then
          -- arm for recording (placeholder)
          loops[x].state = STATE_ARMED
        else
          -- toggle mute/play
          if loops[x].state==STATE_PLAY then
            loops[x].state = STATE_MUTED
          elseif loops[x].state==STATE_MUTED then
            loops[x].state = STATE_PLAY
          end
        end
      end
    elseif x>=11 and x<=16 and z==1 then
      local v = x-10
      loops[v].level = util.clamp((9-y)/8,0,1)
    end
    redraw()
  end
  redraw()
end

function M.panic()
  for v=1,6 do loops[v].state = STATE_EMPTY end
  redraw()
end

return M
