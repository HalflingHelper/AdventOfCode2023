require 'util'

DAY = 5

local filename = string.format("inputs/input_%02d.txt", DAY)

local f = assert(io.open(filename, "r"))

-- Function definitions here
local seeds = {} -- All the seeds, the first line of the file
local data = {}  -- All the maps
local map = {}   -- Current map or whatever

-- It's recursive now
local function getDestination(seed_num, data, start)
    if start == nil then start = 1 end

    local m = data[start]
    if m == nil then
        return seed_num
    end

    local found = nil
    for _, v in ipairs(m) do
        local source = v[1]
        local dest = v[2]

        if seed_num >= source[1] and seed_num <= source[2] then
            found = dest[1] + seed_num - source[1]
        end
    end

    if not found then found = seed_num end

    return getDestination(found, data, start + 1)
end

local function getMinDestination(seed_start, seed_end, data, start)
    if start == nil then start = 2 end -- Because my data is shitty!

    local m = data[start]
    if m == nil then
        return seed_start
    end

    local found = {}
    for _, v in ipairs(m) do
        local source = v[1]
        local dest = v[2]

        if seed_start <= source[2] and seed_end >= source[1] then
            local new_start = math.max(seed_start, source[1])
            local new_end = math.min(seed_end, source[2])

            new_start = new_start - source[1] + dest[1]
            new_end = dest[2] - (source[2] - new_end)

            found[#found + 1] = getMinDestination(new_start, new_end, data, start + 1)
        end
    end

    if #found == 0 then found = { seed_start } end

    local min = math.huge

    for _, v in ipairs(found) do
        min = math.min(min, v)
    end
    return min
end

for line in f:lines() do
    -- Process the file here
    local start = line:match("():")

    if start and #seeds ~= 0 then
        data[#data + 1] = map
        map = {}
        f:read("l")
    elseif #seeds == 0 then
        for s in split(line, " ", start + 1) do
            seeds[#seeds + 1] = tonumber(s)
        end
    else
        local source_start
        local dest_start
        local size
        local i = 1
        for s in split(line, " ") do
            if i == 1 then
                dest_start = tonumber(s)
            elseif i == 2 then
                source_start = tonumber(s)
            elseif i == 3 then
                size = tonumber(s)
            end

            i = i + 1
        end
        if source_start then
            local m = {}
            m[1] = { source_start, source_start + size - 1 }
            m[2] = { dest_start, dest_start + size - 1 }
            map[#map + 1] = m
        end
    end
end

data[#data + 1] = map

-- Do everything else here
local part1 = math.huge
local part2 = math.huge

for i, v in ipairs(seeds) do
    local r = getDestination(v, data)
    part1 = math.min(part1, r)
end

for i = 1, #seeds, 2 do
    local s = seeds[i]
    local l = seeds[i + 1]

    local r = getMinDestination(s, s + l - 1, data)
    part2 = math.min(part2, r)
end


print("Part 1:", part1)
print("Part 2:", part2)
