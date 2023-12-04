require 'util'

DAY = 3

local filename = string.format("inputs/input_%02d.txt", DAY)

local f = assert(io.open(filename, "r"))

-- Function definitions here
local data = {}

for line in f:lines() do
    -- Process the file here
    local row = {}

    for i in line:gmatch("()%d+") do
        local num = line:match("%d+", i)
        row[i] = num
    end

    for i, s in line:gmatch("()([^%.%d])") do
        -- Use a start to represent every special character
        row[i] = s
    end

    data[#data + 1] = row
end

-- Do everything else here

local part1 = 0
local part2 = 0

for j, row in ipairs(data) do
    for x, inf in pairs(row) do
        if  tonumber(inf) then
            local found = false

            local num = tonumber(inf)
            --Look at adjacent
            for i = j - 1, j + 1 do
                for k = x - 1, x + #inf do
                    if data[i] and data[i][k] ~= nil and not tonumber(data[i][k]) then
                        found = true
                    end
                end
            end

            if found then
                part1 = part1 + num
            end
        elseif inf == "*" then
            local n1 = nil
            local n2 = nil
            local n3 = nil

            for i = j-1, j+1 do
                for k = 1, x + 1 do
                    if data[i] and tonumber(data[i][k]) then
                        local e = k + #data[i][k]-1
                        if k <= x+1 and e >= x-1 then
                            n3 = n2 and tonumber(data[i][k]) or nil
                            n2 = n1 and tonumber(data[i][k]) or nil
                            n1 = n1 and n1 or tonumber(data[i][k])
                        end
                    end
                end
            end

            if n3 == nil and n1 and n2 then
                part2 = part2 + n1 * n2
            end
        end
    end
end
print("Part 1:", part1)
print("Part 2:", part2)
