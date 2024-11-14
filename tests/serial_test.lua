local serials = {
    "hello",
    {1,2,3,4},
    test={5,6,7,8},
    {"kanto","johto"},
    test2={hello="world",1,nested={hello2="world2"}}
}

GAME().log("unserialized: "..tostring(serials))

for _,serial in pairs(serials) do 
    local serialized = GAME().core.filehelper.serialize(serial)
    GAME().log(serialized)

    GAME().log("next serial..")
end

GAME().log("\nfinal serial (all):")

local serialized = GAME().core.filehelper.serialize(serials)
GAME().log(serialized)

GAME().log("\n deserialized")

local deserialized = GAME().core.filehelper.deserialize(serialized)

GAME().log("\n\nRESERIALIZED:"..GAME().core.filehelper.serialize(deserialized))
-- for k,v in pairs(deserialized) do 
--     GAME().log(k.."="..v)
-- end
--

GAME().log("testing real values!"..
    deserialized[1]..deserialized["test"][1]..deserialized["test2"]["nested"]["hello2"]
)