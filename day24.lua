require 'util'

DAY = 24

local filename = string.format("inputs/input_%02d.txt", DAY)

local f = assert(io.open(filename, "r"))

-- Function definitions here
local data = {}

for line in f:lines() do
    -- Process the file 
    local x, y, z, vx, vy, vz = line:match("(%-*%d+), (%-*%d+), (%-*%d+) @ (%-*%d+), (%-*%d+), (%-*%d+)")

    data[#data+1] = {
        pos = {x=tonumber(x), y=tonumber(y), z=tonumber(z)},
        velo = {x=tonumber(vx), y=tonumber(vy), z=tonumber(vz)}
    }
end

-- Do everything else here
local part1 = 0
local part2 = 0

local function inBounds(pt, bounds)
    return pt.pos.x >= bounds[1] and pt.pos.x <= bounds[2] and pt.pos.y >= bounds[1] and pt.pos.y <= bounds[2]
end

local function collision(p1, p2)
    local a = -p1.velo.x
    local b = p2.velo.x
    local c = -(p1.pos.x - p2.pos.x)
    local d = -p1.velo.y
    local e = p2.velo.y
    local f = -(p1.pos.y - p2.pos.y)

    local t1 = (b*f - e*c)/(a*e - d*b)
    local t2 = (c*d - f*a)/(e*a - b*d)

    if t1 < 0 or t2 < 0 then
        return nil
    end

    return {pos={x=p2.pos.x + p2.velo.x * t2, y=p2.pos.y + p2.velo.y * t2}}
end

-- local intersectionBounds = {7, 27}
local intersectionBounds = {200000000000000, 400000000000000}

for i, v in ipairs(data) do
    for j = i+1, #data do
       local c = collision(v, data[j]) 

       if c and inBounds(c, intersectionBounds) then
        part1 = part1 + 1
       end
    end
end

print("Part 1:", part1)
print("Part 2:", part2)
