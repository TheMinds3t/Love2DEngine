require("scripts.core.shortcuts")
local util = {}

util.split_string = function(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end

    local t = {}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        insert(t, str)
    end

    return t
end

util.deep_copy = function(obj, seen)
    if type(obj) ~= 'table' then return obj end
    if seen and seen[obj] then return seen[obj] end
    local s = seen or {}
    local res = setmetatable({}, getmetatable(obj))
    s[obj] = res
    for k, v in pairs(obj) do res[util.deep_copy(k, s)] = util.deep_copy(v, s) end
    return res
end

return util