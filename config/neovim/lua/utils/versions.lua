--[[ Functions to compare version strings --]]

local M = {}

---@alias version_fun fun(a: string, b: string): boolean

---Return 0 if versions are equal, -1 if a < b  and 1 if a > b
---@param a string
---@param b string
---@return integer
local function version_cmp(a, b)
  ---@param v string
  ---@return integer[]
  local function split(v)
    local t = {}
    for part in v:gmatch("[^.]+") do
      table.insert(t, tonumber(part) or 0)
    end
    return t
  end

  local va = split(a)
  local vb = split(b)

  local len = math.max(#va, #vb)
  for i = 1, len do
    local pa = va[i] or 0
    local pb = vb[i] or 0
    if pa < pb then return -1 end
    if pa > pb then return 1 end
  end
  return 0
end

---@type version_fun
function M.version_eq(a, b) return version_cmp(a, b) == 0 end

---@type version_fun
function M.version_lt(a, b) return version_cmp(a, b) == -1 end

---@type version_fun
function M.version_le(a, b) return version_cmp(a, b) <= 0 end

---@type version_fun
function M.version_gt(a, b) return version_cmp(a, b) == 1 end

---@type version_fun
function M.version_ge(a, b) return version_cmp(a, b) >= 0 end

return M
