require 'util'

DAY = 2

local filename = string.format("inputs/input_%d.txt", DAY)

local f = assert(io.open(filename, "r"))

-- Function definitions here
local data = {}

local colors = {["red"]=12, ["green"]=13, ["blue"]=14 }

for line in f:lines() do
    -- Process the file here
    local gameT = {}

    -- Index where the data starts
    local start = line:match("():")

    for game in split(line, ";" , start + 1) do
        local drawT = {}

        for draw in split(game, ",") do
            local color = false
            for c, _ in pairs(colors) do
                local m = draw:match("()" .. c)
                if m then
                    drawT[c] = tonumber(draw:sub(1, m-1))
                    color = true
                end
            end
            if not color then
                print("INVALID COLOR FOUND in line "..line)
            end
        end

        table.insert(gameT, drawT)
    end
    table.insert(data, gameT)
end

local res1 = 0
local res2 = 0
-- Do everything else here
for i, game in ipairs(data) do
    local possible = true

    local mins = {["red"]=0, ["green"]=0, ["blue"]=0 }

    for _, draw in ipairs(game) do
        for col, num in pairs(draw) do
            if num > colors[col] then
                possible = false
            end

            mins[col] = math.max(mins[col], num)
        end
    end

    -- Increment possible for part 1
    if possible then 
        res1 = res1 + i
    end

    -- Calculate the power for part 2
    local power = 1
    for col, num in pairs(mins) do
        power = power * num
    end
    res2 = res2 + power
end

print("Part 1:", res1)
print("Part 2:", res2)
