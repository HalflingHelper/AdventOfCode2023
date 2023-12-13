require 'util'

DAY = 13

local filename = string.format("inputs/input_%02d.txt", DAY)

local f = assert(io.open(filename, "r"))

-- Function definitions here
local data = {}

local function getSymettryIndex(chunk, change)
    -- For every possible index we bubble out, make the change we need to, and then return if success
    for i = 1, #chunk - 1 do
        local changed = change and true or false
        local correct = true

        for d = 0, #chunk do
            local l1 = chunk[i - d]
            local l2 = chunk[i + d + 1]

            if l1 == nil or l2 == nil then break end

            if l1 ~= l2 then
                if changed then
                    correct = false
                    break
                end
                for j = 1, #l1 do
                    if l1:sub(j, j) ~= l2:sub(j, j) then
                        if changed then
                            correct = false
                            break
                        end
                        changed = true
                    end
                end
            end
        end

        if changed and correct then
            return i
        end
    end

    return 0
end

local chunk = {}
for line in f:lines() do
    -- Process the file here
    if #line == 0 then 
        data[#data+1] = chunk
        chunk = {}
    else
        chunk[#chunk+1] = line
    end
end
-- Add the last chunk
data[#data+1] = chunk

-- Do everything else here
local part1 = 0
local part2 = 0

for _, chunk in ipairs(data) do
    part1 = part1 + getSymettryIndex(chunk, true) * 100 + getSymettryIndex(get_columns(chunk), true)
    part2 = part2 + getSymettryIndex(chunk)       * 100 + getSymettryIndex(get_columns(chunk))
end

print("Part 1:", part1)
print("Part 2:", part2)
