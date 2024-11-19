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
-- 27.3 (56 / 205)
util.interpolate_color = function(cola, colb, perc)
    local ar, ag, ab, aa = love.math.colorToBytes(cola.r, cola.g, cola.b, cola.a)
    local br, bg, bb, ba = love.math.colorToBytes(colb.r, colb.g, colb.b, colb.a)

    aa = aa == nil and 255 or aa 
    ba = ba == nil and 255 or ba 

    return love.math.colorFromBytes(
        math.max(0,math.min(255,ar * (1.0 - perc) + br * perc)),
        math.max(0,math.min(255,ag * (1.0 - perc) + bg * perc)),
        math.max(0,math.min(255,ab * (1.0 - perc) + bb * perc)),
        math.max(0,math.min(255,aa * (1.0 - perc) + ba * perc)))
end

util.interpolate_transform = function(transa, transb, perc)
    local ax, ay, ar, asx, asy, aox, aoy, ashx, ashy = transa:getMatrix()
    local bx, by, br, bsx, bsy, box, boy, bshx, bshy = transb:getMatrix()
    return love.math.newTransform(
        ax * (1.0 - perc) + bx * perc,
        ay * (1.0 - perc) + by * perc,
        ar * (1.0 - perc) + br * perc,
        asx * (1.0 - perc) + bsx * perc,
        asy * (1.0 - perc) + bsy * perc,
        aox * (1.0 - perc) + box * perc,
        aoy * (1.0 - perc) + boy * perc,
        ashx * (1.0 - perc) + bshx * perc,
        ashy * (1.0 - perc) + bshy * perc)
end

return util