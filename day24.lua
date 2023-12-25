require 'util'

DAY = 24

local filename = string.format("inputs/input_%02d.txt", DAY)

local f = assert(io.open(filename, "r"))

-- Function definitions here
local data = {}
local err = 0.1

for line in f:lines() do
    -- Process the file
    local x, y, z, vx, vy, vz = line:match("(%-*%d+), (%-*%d+), (%-*%d+) @ (%-*%d+), (%-*%d+), (%-*%d+)")

    data[#data + 1] = {
        pos = { x = tonumber(x), y = tonumber(y), z = tonumber(z) },
        velo = { x = tonumber(vx), y = tonumber(vy), z = tonumber(vz) }
    }
end

-- Do everything else here
local part1 = 0
local part2 = 0

local function inBounds(pt, bounds)
    return pt.pos.x >= bounds[1] and pt.pos.x <= bounds[2] and pt.pos.y >= bounds[1] and pt.pos.y <= bounds[2]
end

local function intersect(p1, p2)
    local a = -p1.velo.x
    local b = p2.velo.x
    local c = -(p1.pos.x - p2.pos.x)
    local d = -p1.velo.y
    local e = p2.velo.y
    local f = -(p1.pos.y - p2.pos.y)

    local t1 = (b * f - e * c) / (a * e - d * b)
    local t2 = (c * d - f * a) / (e * a - b * d)

    if t1 < 0 or t2 < 0 then
        return nil
    end

    return { pos = { x = p2.pos.x + p2.velo.x * t2, y = p2.pos.y + p2.velo.y * t2 } }
end

local function appEq(v1, v2)
    return math.abs(v1[1] - v2[1]) < err and math.abs(v1[2] - v2[2]) < err and math.abs(v1[3] - v2[3]) < err
end

-- Returns the point at which the lines intersect
-- Returns nil if no such point
-- Offset is velocity offset
local function collision3D(p1, p2, offset)
    local a = -(p1.velo.x - offset[1])
    local b = p2.velo.x - offset[1]
    local c = -(p1.pos.x - p2.pos.x)
    local d = -(p1.velo.y - offset[2])
    local e = p2.velo.y - offset[2]
    local f = -(p1.pos.y - p2.pos.y)

    -- Find where they intersect
    local t1 = (b * f - e * c) / (a * e - d * b)
    local t2 = (c * d - f * a) / (e * a - b * d)

    if t1 < 0 or t2 < 0 or math.abs((p1.pos.z + t1 * (p1.velo.z - offset[3])) - (p2.pos.z + t2 * (p2.velo.z - offset[3]))) >= err then
        return nil
    end

    return { p2.pos.x + (p2.velo.x - offset[1]) * t2, p2.pos.y + (p2.velo.y - offset[2]) * t2, p2.pos.z +
    t2 * (p2.velo.z - offset[3]) }
end

-- local intersectionBounds = {7, 27} -- For test data
local intersectionBounds = { 200000000000000, 400000000000000 }

for i, v in ipairs(data) do
    for j = i + 1, #data do
        local c = intersect(v, data[j])

        if c and inBounds(c, intersectionBounds) then
            part1 = part1 + 1
        end
    end
end

local veloCap = 300 -- Just increased until I got something that worked

for i = -veloCap, veloCap do
    for j = -veloCap, veloCap do
        for k = -veloCap, veloCap do
            -- I assume it's safe to use just 4 rocks since there's so many unknowns
            local trialpt = collision3D(data[1], data[2], { i, j, k })
            local trialpt2= collision3D(data[3], data[4], { i, j, k })
            local valid = true
            if trialpt and trialpt2 and appEq(trialpt, trialpt2) then
                part2 = math.floor(trialpt[1] + trialpt[2] + trialpt[3])
                goto yay
            end
        end
    end
end

::yay::

print("Part 1:", part1)
print("Part 2:", part2) --828418331313365
