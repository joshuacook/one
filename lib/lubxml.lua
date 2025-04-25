-- ultra‑tiny XML builder / saver (placeholder)
local M={}
function M.new(tag,attrs)
  return {tag=tag,attrs=attrs or {},childs={},add_child=function(self,t,a)
    local c=M.new(t,a);table.insert(self.childs,c);return c end}
end
local function attrs(t)
  local s="";for k,v in pairs(t) do s=s.." "..k..'="'..v..'"' end;return s end
local function dump(node,depth)
  local ind=string.rep("  ",depth)
  local out=ind.."<"..node.tag..attrs(node.attrs)..">"
  if #node.childs>0 then out=out.."\n";for _,c in ipairs(node.childs) do out=out..dump(c,depth+1)end
    out=out..ind.."</"..node.tag..">\n" else out=out.."</"..node.tag..">\n" end return out end
function M.save(node,fn) local f=io.open(fn,"w");f:write(dump(node,0));f:close() end
function M.load(fn) return nil end
return M
