require 'util'

DAY = 9

local filename = string.format("inputs/input_%02d.txt", DAY)

local f = assert(io.open(filename, "r"))

-- Function definitions here
local data = {}

local function extrapolate(seq)      --Extrapolates the values at both the front and back
    if #seq == 0 then return { 0 } end -- Assuming this basecase

    local allZero = seq[1] == 0
    local next = {}

    for i = 2, #seq do
        next[#next + 1] = seq[i] - seq[i - 1]
        allZero = allZero and seq[i] == 0
    end

    next = extrapolate(next)
    seq[#seq + 1] = next[#next] + seq[#seq]
    table.insert(seq, 1, seq[1] - next[1])
    return seq
end

for line in f:lines() do
    -- Process the file here
    local row = {}
    for n in split(line, " ") do
        row[#row + 1] = tonumber(n)
    end
    data[#data + 1] = row
end

-- Do everything else here
local part1 = 0
local part2 = 0

for i, v in ipairs(data) do
    local e = extrapolate(v)
    part1 = part1 + e[#e]
    part2 = part2 + e[1]
end

print("Part 1:", part1)
print("Part 2:", part2)
