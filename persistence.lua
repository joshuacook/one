-- jf_looper/persistence.lua
local xml   = include("jf_looper/lib/lubxml")
local util  = require("util")
local M = {}

local loops_ref -- we'll fetch from grid module later

local function proj_path(name)
  return _path.data .. "jf_looper/projects/" .. name .. "/"
end

function M.save(name, loops)
  local dir = proj_path(name)
  os.execute("mkdir -p " .. dir)
  local doc = xml.new("project")
  for v,l in ipairs(loops) do
    if l.state ~= 0 then
      doc:add_child("loop",{id=v, level=l.level, muted=(l.state==4 and 1 or 0), file=string.format("%03d.wav",v-1)})
      -- softcut.buffer_write_mono(...) placeholder
    end
  end
  xml.save(doc, dir.."project.xml")
  util.file_write(_path.data.."jf_looper/jf_looper_autoload.txt", name)
end

function M.autoload()
  local name = util.read(_path.data.."jf_looper/jf_looper_autoload.txt")
  -- load logic later
end

function M.save_current()
  M.save(os.date("%Y%m%d_%H%M%S"), loops_ref or {})
end

function M.choose_and_load() print("TODO: chooser UI") end

return M
