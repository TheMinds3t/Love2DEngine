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
    return {
        r=math.max(0,math.min(255,cola.r * (1.0 - perc) + colb.r * perc)),
        g=math.max(0,math.min(255,cola.g * (1.0 - perc) + colb.g * perc)),
        b=math.max(0,math.min(255,cola.b * (1.0 - perc) + colb.b * perc)),
        a=math.max(0,math.min(255,cola.a * (1.0 - perc) + colb.a * perc))
    }
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

util.round = function(num, sig_figs)
    return math.floor(num*10^sig_figs) / 10 ^ (sig_figs - 2)
end

util.split_dict = function(dict, flip_result)
    flip_result = flip_result == nil and false or flip_result
    local keyset = {}
    local valset = {}

    for key,val in pairs(dict) do 
        insert(keyset, key)
        insert(valset, val)
    end

    if flip_result then return valset, keyset else 
    return keyset, valset end
end

return util