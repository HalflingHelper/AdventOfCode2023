require 'util'

DAY = 6

local filename = string.format("inputs/input_%02d.txt", DAY)

local f = assert(io.open(filename, "r"))

-- Function definitions here
local data = {}  -- {times, distances}
local data2 = {} -- {time, distance}

local function getWays(n, d)
    local low = math.floor((-n + math.sqrt(n ^ 2 - 4 * d)) / -2 + 1)
    local high = math.ceil((-n - math.sqrt(n ^ 2 - 4 * d)) / -2 - 1)

    low = math.max(low, 0)
    high = math.min(high, (n - 1))

    return high - low + 1
end

for line in f:lines() do
    -- Process the file here
    local start = line:match(":()")
    local row = {}
    local row2 = ""

    for s in split(line, " ", start) do
        row[#row + 1] = tonumber(s)
        row2 = row2 .. s
    end
    data[#data + 1] = row
    data2[#data2 + 1] = row2
end

-- Do everything else here
local part1 = 1
local part2 = 0

local times = data[1]
local distances = data[2]

for i = 1, #times do
    part1 = part1 * getWays(times[i], distances[i])
end

part2 = getWays(tonumber(data2[1]), tonumber(data2[2]))

print("Part 1:", part1)
print("Part 2:", part2)

-- Explanation / Working Out
-- Given a race duration n, your distance is equal to
-- x*(n-x), given a duration of holding the button, x

-- We want to determine for how many values of m is x*(n-x) greater than some distance, d
-- -x^2 + xn - d > 0
-- For a value of n, x = [-n +/- sqrt(n^2 - 4 * 1 * d)]/-2 (By the quadratic formula)
-- In the code we do some stuffs with floor/ceil to ensure that the value is an integer and that the distance doesn't equal d
