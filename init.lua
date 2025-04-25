-- jf_looper / init.lua
-- Skeleton for 4‑bar grid looper (Monome + Softcut)
engine.name = "None" -- pure softcut, no SuperCollider synths

local sc      = softcut
local g       = grid.connect()
local ui      = include("ui")
local griddrv = include("grid")
local persist = include("persistence")

-- Param definitions ---------------------------------------------------------
params:add_option("grid_rot", "grid rotation", {"0","90","180","270"}, 1)
params:add_number("bpm", "tempo", 20, 300, 120)
params:add_number("fade_ms", "fade (ms)", 2, 100, 10)
params:add{type="trigger", id="save_proj", name="save project", action = function() persist.save_current() end}
params:add{type="trigger", id="load_proj", name="load project", action = function() persist.choose_and_load() end}
params:bang()

-- Softcut -------------------------------------------------------------------
local function beats_to_sec(beats)
  return beats * (60 / params:get("bpm"))
end

local function setup_softcut()
  local len = beats_to_sec(16)
  for v=1,6 do
    sc.buffer(v, 1)
    sc.level(v, 0)
    sc.loop(v, 1)
    sc.loop_start(v, 0)
    sc.loop_end(v, len)
    sc.fade_time(v, params:get("fade_ms")/1000)
    sc.rec(v, 0)
    sc.play(v, 0)
    sc.position(v, 0)
  end
end

-- Transport -----------------------------------------------------------------
local running = false
local clk

local function start()
  if running then return end
  clk = clock.run(function()
    while true do
      clock.sync(1)
      griddrv.tick()
      ui.tick()
    end
  end)
  midi_clock_start()
  running = true
end

local function stop()
  if not running then return end
  clock.cancel(clk)
  midi_clock_stop()
  running = false
end

function key(n,z)
  if z==0 then return end
  if n==2 then
    if running then stop() else start() end
  elseif n==3 then
    stop()
    griddrv.panic()
  end
end

function init()
  setup_softcut()
  griddrv.init(g)
  ui.init()
  persist.autoload()
end

function redraw()
  ui.redraw()
end
