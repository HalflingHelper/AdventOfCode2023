require 'util'

DAY = 16

local filename = string.format("inputs/input_%02d.txt", DAY)

local f = assert(io.open(filename, "r"))

-- Function definitions here
local data = {}
local hits = {} -- So that we don't hit a mirror in the same direction twice
local visited = {} -- So that we don't double count a cell

-- Returns the number of energized cells
local function shootLight(data, row, col, dir)
    if not data[row] or not data[row][col] then
        return 0 -- Out of bounds
    end

    if hits[row.."|"..col.."|"..dir[1].."|"..dir[2]] then
        return 0
    end

    hits[row.."|"..col.."|"..dir[1].."|"..dir[2]] = true

    local a = visited[row.."|"..col] and 0 or 1
    visited[row.."|"..col] = true

    local mirror = data[row][col]

    if mirror == "." then
        return a + shootLight(data, row + dir[1], col + dir[2], dir)
    elseif mirror == "/" then
        local newDir = {-dir[2], -dir[1]}
        return a + shootLight(data, row + newDir[1], col + newDir[2], newDir)
    elseif mirror == "\\" then
        local newDir = {dir[2], dir[1]}
        return a + shootLight(data, row + newDir[1], col + newDir[2], newDir)
    elseif mirror == "|" then
        if dir[2] == 0 then
            return a + shootLight(data, row + dir[1], col + dir[2], dir)
        else
            return a + shootLight(data, row + 1, col, {1, 0}) + shootLight(data, row - 1, col, {-1, 0})
        end
    elseif mirror == "-" then
        if dir[1] == 0 then
            return a + shootLight(data, row + dir[1], col + dir[2], dir)
        else
            return a + shootLight(data, row, col + 1, {0, 1}) + shootLight(data, row, col - 1, {0, -1})
        end
    end
end

local function callShootLight(data, row, col, dir)
    visited = {}
    hits = {}
    return shootLight(data, row, col, dir)

end

for line in f:lines() do
    -- Process the file here
    local row = {}
    for c in chars(line) do
        row[#row+1] = c
    end
    data[#data+1] = row
end

-- Do everything else here
local part1 = callShootLight(data, 1, 1, {0, 1})
local part2 = part1

for eRow = 1, #data do
    part2 = math.max(part2, callShootLight(data, eRow, 1, {0, 1}), callShootLight(data, eRow, #data[eRow], {0, -1}))
end

for eCol = 1, #data[1] do
    part2 = math.max(part2, callShootLight(data, 1, eCol, {1, 0}), callShootLight(data, #data, eCol, {-1, 0}))
end

print("Part 1:", part1)
print("Part 2:", part2)
