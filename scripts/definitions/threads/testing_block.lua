require("scripts.core.constants")
local last = 0
for i=1,9999999999 do 
    last = i
end

love.thread.getChannel(C_THREADS_BLOCKING_CHANNEL):push("done!")