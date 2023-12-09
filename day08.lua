require 'util'

DAY = 8

local filename = string.format("inputs/input_%02d.txt", DAY)

local f = assert(io.open(filename, "r"))

-- Function definitions here
local data = {}

local directions = f:read()
_ = f:read() -- blank line

for line in f:lines() do
    -- Process the file here
    local node, l, r = line:match("(%w+) = %((%w+), (%w+)%)")
    data[node] = { L = l, R = r }
end
-- Do everything else here
local part1 = 0
local part2 = 0

local curs = {}
for k, _ in pairs(data) do
    if k:sub(3, 3) == "A" then
        curs[#curs + 1] = k --cur
    end
end

local found = false
local cur = "AAA"
while not found do
    for c in chars(directions) do
        if not found then
            part1 = part1 + 1
            cur = data[cur][c]
            if cur == "ZZZ" then
                found = true
            end
        end
    end
end


-- For part2
-- For all of the nodes, see where they end up after a full cycle of the directions, marking the steps
--  at which there is a node ending in Z
local curtimes = {}

for i, k in ipairs(curs) do
    found = false
    local cur = k
    local steps = 0
    while not found do
        for c in chars(directions) do
            cur = data[cur][c]
            steps = steps + 1
            if cur:sub(3, 3) == "Z" then
                found = true
                break
            end
        end
    end
    curtimes[#curtimes + 1] = steps

end

part2 = 1
for i, v in ipairs(curtimes) do
    part2 = lcm(part2, v)
end


print("Part 1:", part1)
print("Part 2:", part2)
