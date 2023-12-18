require 'util'

DAY = 18

local filename = string.format("inputs/input_%02d.txt", DAY)

local f = assert(io.open(filename, "r"))

-- Function definitions here
local edges = {}
local edges2 = {} -- For part 2

local dirs = {
    U = { 0, -1 },
    D = { 0, 1 },
    L = { -1, 0 },
    R = { 1, 0 },
    ["0"] = { 1, 0 },
    ["1"] = { 0, 1 },
    ["2"] = { -1, 0 },
    ["3"] = { 0, -1 }
}

local curX, curY = 0, 0
local x1, x2, y1, y2 = 0, 0, 0, 0 -- Bounds of the area

local p2 = {curX = 0, curY = 0, x1 = 0, x2=0, y1=0, y2=0}

for line in f:lines() do
    -- Process the file here
    local dir, num, col = line:match("(%a) (%w+) %((.+)%)")
    num = tonumber(num)
    local e = { x1 = curX, y1 = curY, x2 = curX + num * dirs[dir][1], y2 = curY + num * dirs[dir][2] }
    curX = curX + num * dirs[dir][1]
    curY = curY + num * dirs[dir][2]

    x1 = math.min(curX, x1)
    x2 = math.max(curX, x2)
    y1 = math.min(curY, y1)
    y2 = math.max(curY, y2)
    edges[#edges + 1] = e

    local hexNum, dir = col:match("#(%w%w%w%w%w)(%w)")
    hexNum = tonumber(hexNum, 16)

    local e2 = { x1 = p2.curX, y1 = p2.curY, x2 = p2.curX + hexNum * dirs[dir][1], y2 = p2.curY + hexNum * dirs[dir][2] }
    p2.curX = p2.curX + hexNum * dirs[dir][1]
    p2.curY = p2.curY + hexNum * dirs[dir][2]

    p2.x1 = math.min(p2.curX, p2.x1)
    p2.x2 = math.max(p2.curX, p2.x2)
    p2.y1 = math.min(p2.curY, p2.y1)
    p2.y2 = math.max(p2.curY, p2.y2)

    edges2[#edges2+1] = e2
end

-- Do everything else here
local part1 = 0
local part2 = 0

-- Tracking the edges not in the interior of the polygon
local missed = 1
-- Using Shoelace: https://en.wikipedia.org/wiki/Shoelace_formula
for _, e in ipairs(edges) do
    if e.y2 > e.y1 or e.x2 < e.x1 then
        missed = missed + (e.x1 - e.x2) + (e.y2 - e.y1)
    end
    part1 = part1 + (e.x1 * e.y2 - e.x2 * e.y1)
end
part1 = math.floor(part1 / 2 + missed)

missed = 1
for _, e in ipairs(edges2) do
    if e.y2 > e.y1 or e.x2 < e.x1 then
        missed = missed + (e.x1 - e.x2) + (e.y2 - e.y1)
    end
    part2 = part2 +  (e.x1 * e.y2 - e.x2 * e.y1)
end
part2 = math.floor(part2/2 + missed)

print("Part 1:", part1)
print("Part 2:", part2)
