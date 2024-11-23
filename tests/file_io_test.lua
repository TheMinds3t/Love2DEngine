local test_data = {
    hello="world",
    foo="bar",
    data={1,2,3,4,nested={5,6,7,8}}
}

local file = GAME().filehelper.write_file("testing.txt", function() 
    return {GAME().filehelper.serialize(test_data)}
end)

if file then 
    GAME().log("wrote output! testing reading...\n")

    local read_file = GAME().filehelper.read_file("testing.txt")

    for line in read_file do 
        GAME().log(line)
    end
else
    GAME().log("failed to write output!")
end
