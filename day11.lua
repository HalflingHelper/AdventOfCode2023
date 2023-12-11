require 'util'

DAY = 11

local filename = string.format("inputs/input_%02d.txt", DAY)

local f = assert(io.open(filename, "r"))

-- Function definitions here
local data = {}
local nonEmptyRows = {}
local nonEmptyCols = {}

local function galaxyDistance(g1, g2, oRows, oCols, expansion)
    local res = 0
    local dir
    dir = sign(g2[1] - g1[1])
    for row = g1[1] + dir, g2[1], dir do
        res = res + (oRows[row] and 1 or expansion)
    end
    dir = sign(g2[2] - g1[2])
    for col = g1[2] + dir, g2[2], dir do
        res = res + (oCols[col] and 1 or expansion)
    end
    return res
end

local row = 1
for line in f:lines() do
    -- Process the file here
    for i in line:gmatch("()#") do
        nonEmptyCols[i] = true
        nonEmptyRows[row] = true

        data[#data + 1] = { row, i }
    end
    row = row + 1
end

-- Do everything else here
local part1 = 0
local part2 = 0

for i, g1 in ipairs(data) do
    for j = i + 1, #data do
        local g2 = data[j]
        part1 = part1 + galaxyDistance(g1, g2, nonEmptyRows, nonEmptyCols, 2)
        part2 = part2 + galaxyDistance(g1, g2, nonEmptyRows, nonEmptyCols, 1000000)
    end
end

print("Part 1:", part1)
print("Part 2:", part2)
