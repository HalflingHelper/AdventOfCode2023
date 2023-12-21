require 'util'

DAY = 21

local filename = string.format("inputs/input_%02d.txt", DAY)

local f = assert(io.open(filename, "r"))

-- Function definitions here
local data = {}
local data2 = {}
local start = ""

for line in f:lines() do
    -- Process the file here
    local row = {}
    local row2 = {}
    for c in chars(line) do
        if c == "S" then start = (#row + 1) .. "," .. (#data + 1) end
        row[#row + 1] = c
        row2[#row2 + 1] = c
    end
    data[#data + 1] = row
    data2[#data2 + 1] = row2
end

-- Do everything else here
local part1 = 0
local part2 = 0

local function takeStep(data)
    local dests = {}

    for i, row in ipairs(data) do
        for j, col in ipairs(row) do
            if col == "O" or col == "S" then
                for _, dir in ipairs({ { 1, 0 }, { 0, 1 }, { -1, 0 }, { 0, -1 } }) do
                    if data[i + dir[1]] and data[i + dir[1]][j + dir[2]] ~= "#" then
                        dests[i + dir[1] .. "," .. j + dir[2]] = true
                    end
                end
                data[i][j] = "."
            end
        end
    end

    for k, v in pairs(dests) do
        local row, col = k:match("(%-*%d+),(%-*%d+)")
        data[tonumber(row)][tonumber(col)] = "O"
    end
end

for i = 1, 64 do
    takeStep(data)
end

for i, row in ipairs(data) do
    for j, col in ipairs(row) do
        if col == "O" or col == "S" then
            part1 = part1 + 1
        end
    end
end

-- Part 2 - Naive way with expanding wavefront
-- Way too slow
local function getCell(hash)
    local row, col = hash:match("(%-*%d+),(%-*%d+)")
    row = tonumber(row) % #data
    if row == 0 then row = #data end

    col = tonumber(col) % #data[1]
    if col == 0 then col = #data[1] end

    return data[row][col]
end

local function f(steps)
    local targetParity = steps % 2
    local count = 0
    local visited = { [start] = true }
    local waveFront = { { start:match("(%-*%d+),(%-*%d+)") } }
    for i = 1, steps do
        local newFront = {}
        for j, v in ipairs(waveFront) do
            local row, col = v[1], v[2]

            if (row + col) % 2 == targetParity then
                count = count + 1
            end
           
            for _, dir in ipairs({ { 1, 0 }, { 0, 1 }, { -1, 0 }, { 0, -1 } }) do
                local h = (row + dir[1]) .. "," ..( col + dir[2])
                if not visited[h] then
                    visited[h] = true
                    if getCell(h) ~= "#" then
                        newFront[#newFront + 1] = { row + dir[1], col + dir[2] }
                    end
                end
            end
        end
        waveFront = newFront
    end
    for j, v in ipairs(waveFront) do
        local row, col = v[1], v[2]

        if (row + col) % 2 == targetParity then
            count = count + 1
        end
    end
    return count
end

-- Credit to this https://github.com/SPixs/AOC2023/blob/master/src/Day21.java for quadratic method
local function interp(x, x1, y1, x2, y2, x3, y3)
    return (((x-x2) * (x-x3)) / ((x1-x2) * (x1-x3)) * y1 +
    ((x-x1) * (x-x3)) / ((x2-x1) * (x2-x3)) * y2 +
    ((x-x1) * (x-x2)) / ((x3-x1) * (x3-x2)) * y3)
end

local stepCount = 26501365
local gridSize = 131
local distToEdge = 65

part2 = math.floor(interp(math.floor(stepCount / gridSize), 0, f(distToEdge), 1, f(distToEdge + gridSize), 2, f(distToEdge + 2*gridSize)))

print("Part 1:", part1)
print("Part 2:", part2)
