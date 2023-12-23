require 'util'

DAY = 22

local filename = string.format("inputs/input_%02d.txt", DAY)

local f = assert(io.open(filename, "r"))

-- Function definitions here
local bricks = {}
local timesToDisintegrate = {}

for line in f:lines() do
    -- Process the file here
    local x1, y1, z1, x2, y2, z2 = line:match("(%d+),(%d+),(%d+)~(%d+),(%d+),(%d+)")
    bricks[#bricks + 1] = {
        x1 = tonumber(x1),
        y1 = tonumber(y1),
        z1 = tonumber(z1),
        x2 = tonumber(x2),
        y2 = tonumber(y2),
        z2 =
            tonumber(z2)
    }
    timesToDisintegrate[#timesToDisintegrate + 1] = 1
end

-- Do everything else here
local part1 = 0
local part2 = 0


-- I can sort the bricks by Z axis and then drop them down
table.sort(bricks, function(a, b) return a.z1 < b.z1 end)

-- Drop the bricks
for i, b in ipairs(bricks) do
    local newZ1 = 1

    for j = 1, #bricks do
        local a = bricks[j]
        if j ~= i and a.z2 < b.z1 and a.x1 <= b.x2 and a.x2 >= b.x1 and a.y1 <= b.y2 and a.y2 >= b.y1 then
            newZ1 = math.max(newZ1, a.z2 + 1)
        end
    end

    local zDiff = b.z1 - newZ1
    b.z1 = b.z1 - zDiff
    b.z2 = b.z2 - zDiff
end

-- Returns true if brick a supports brick b
local function supports(a, b)
    return a.z2 + 1 == b.z1 and a.x1 <= b.x2 and a.x2 >= b.x1 and a.y1 <= b.y2 and a.y2 >= b.y1
end

-- For every brick
for i, a in ipairs(bricks) do
    local sameTier = {}
    local supporting = {}

    for j, b in ipairs(bricks) do
        if b.z2 == a.z2 and j ~= i then
            sameTier[#sameTier + 1] = b
        elseif supports(a, b) then
            supporting[#supporting + 1] = b
        end
    end

    local canDelete = true

    for j, b in ipairs(supporting) do
        local otherSupport = false
        for k, a1 in ipairs(sameTier) do
            otherSupport = otherSupport or supports(a1, b)
        end
        canDelete = canDelete and otherSupport
    end

    if canDelete then part1 = part1 + 1 end
end

-- Returns the number of bricks to fall if the bricks at the given indices were removed
-- The problem is that we don't do it all in a row
-- So can we rewrite this recursive function with a heap?
local compMetatable = {} -- So that I can compare tables like tuples 💀
compMetatable.__eq = function(a, b) return a[1] == b[1] end
compMetatable.__lt = function(a, b) return a[1] < b[1] end
compMetatable.__le = function(a, b) return a[1] <= b[1] end

-- Sort bricks by z1 (To make it easier to find above bricks)
table.sort(bricks, function(a, b) return a.z1 < b.z1 end)

local function n(i)
    local count = -1
    -- A priority queue based on z2, so we always are removing the lowest down brick
    local curs = { setmetatable({ bricks[i].z2, i }, compMetatable) }
    local gone = {}

    while #curs ~= 0 do
        local cur = removeHeap(curs)
        local a = cur[2]
        gone[a] = true
        count = count + 1

        -- Find the bricks that cur supports and is not supported by other unremoved bricks
        for b = a + 1, #bricks do
            if supports(bricks[a], bricks[b]) then
                -- b is a candidate to fall
                local willFall = true
                for c = 1, #bricks do
                    if supports(bricks[c], bricks[b]) and not gone[c] then
                        -- Make sure that c has not been visited
                        willFall = false
                    end
                end

                if willFall then
                    local ins = true
                    for _, item in ipairs(curs) do
                        if item[2] == b then ins = false end
                    end
                    if ins then
                        insertHeap(curs, setmetatable({ bricks[b].z2, b }, compMetatable))
                    end
                end
            end
        end
    end

    return count
end


for i = 1, #bricks do
    part2 = part2 + n(i)
end

print("Part 1:", part1)
print("Part 2:", part2)
