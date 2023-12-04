require 'util'

DAY = _

local filename = string.format("inputs/input_%02d.txt", DAY)

local f = assert(io.open(filename, "r"))

-- Function definitions here
local data = {}

for line in f:lines() do
    -- Process the file here

end

-- Do everything else here
local part1 = 0
local part2 = 0

print("Part 1:", part1)
print("Part 2:", part2)
