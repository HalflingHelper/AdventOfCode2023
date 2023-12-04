require 'util'

DAY = 4

local filename = string.format("inputs/input_%02d.txt", DAY)

local f = assert(io.open(filename, "r"))

-- Function definitions here
local data = {}

for line in f:lines() do
    -- Process the file here
    local dline = {score=0,winning={}, mine={}}

    -- Index where the data starts
    local start = line:match("():")
    local mynumbers = false

    for num in split(line, " ", start + 1) do
        if num == "|" then
            mynumbers = true
        else
            local n = tonumber(num)
            if not n then
                print("Invalid data at line", line)
                break
            end

            if mynumbers then
                dline.mine[n] = true
            else
                dline.winning[n] = true
            end
        end
    end

    data[#data + 1] = dline
end

-- Do everything else here
local part1 = 0
local part2 = 0

local copies = {}

for i, game in ipairs(data) do
    local count = 0
    for n, _ in pairs(game.mine) do
        if game.winning[n] then
            count = count + 1
        end
    end

    game.score = count

    if count > 0 then
        part1 = part1 + 2^(count-1)
    end

    part2 = part2 + 1
    for j = i+1, i+count do
        copies[#copies+1] = {index=j, game=data[j]}
    end
end

while #copies > 0 do
    part2 = part2 + 1
    local g = table.remove(copies)
    for j = g.index+1, g.index + g.game.score do
        if (data[j]) then
            copies[#copies+1] = {index=j, game=data[j]}
        end
    end
end

print("Part 1:", part1)
print("Part 2:", part2)
