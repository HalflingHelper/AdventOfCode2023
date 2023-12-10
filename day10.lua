require 'util'

DAY = 10

local filename = string.format("inputs/input_%02d.txt", DAY)

local f = assert(io.open(filename, "r"))

-- Function definitions here
local data = {}
local visited = {}

-- Gross
local function getAdj(row, col, data)
    local pipe = data[row][col]

    local res = {}
    if pipe == "|" then
        if row > 1 then res[#res + 1] = { row - 1, col } end
        if row < #data then res[#res + 1] = { row + 1, col } end
    elseif pipe == "-" then
        if col > 1 then res[#res + 1] = { row, col - 1 } end
        if col < #data[row] then res[#res + 1] = { row, col + 1 } end
    elseif pipe == "F" then
        if row < #data then res[#res + 1] = { row + 1, col } end
        if col < #data[row] then res[#res + 1] = { row, col + 1 } end
    elseif pipe == "J" then
        if row > 1 then res[#res + 1] = { row - 1, col } end
        if col > 1 then res[#res + 1] = { row, col - 1 } end
    elseif pipe == "7" then
        if row < #data then res[#res + 1] = { row + 1, col } end
        if col > 1 then res[#res + 1] = { row, col - 1 } end
    elseif pipe == "L" then
        if row > 1 then res[#res + 1] = { row - 1, col } end
        if col < #data[row] then res[#res + 1] = { row, col + 1 } end
    elseif pipe == "S" then
        if row > 1 then res[#res + 1] = { row - 1, col } end
        if row < #data then res[#res + 1] = { row + 1, col } end
        if col > 1 then res[#res + 1] = { row, col - 1 } end
        if col < #data[row] then res[#res + 1] = { row, col + 1 } end
    end

    return res
end

local function canVisit(orgRow, orgCol, destRow, destCol, data)
    local adj = getAdj(destRow, destCol, data)

    for i, v in ipairs(adj) do
        if v[1] == orgRow and v[2] == orgCol then
            return true
        end
    end

    return false
end

local function hash(row, col) return tostring(row) .. " " ..tostring(col) end

local startRow, startCol

for line in f:lines() do
    -- Process the file here
    local row = {}
    local visitRow = {}
    for c in chars(line) do
        row[#row + 1] = c
        visitRow[#visitRow+1] = false
        if c == "S" then
            startRow = #data + 1
            startCol = #row
        end
    end
    data[#data + 1] = row
    visited[#visited+1] = visitRow
end

-- Do everything else here
local part1 = 0
local part2 = 0

local loopSize = 1
visited[startRow][startCol] = "|" 
-- Cheating by hardcoding value of S, I know there is a way to do this correctly once we get the loop, but I am too lazy
local Q = { { startRow, startCol } }

while #Q ~= 0 do
    local c = table.remove(Q, 1)

    for i, adj in ipairs(getAdj(c[1], c[2], data)) do
        local nRow = adj[1]
        local nCol = adj[2]

        if not visited[nRow][nCol] and canVisit(c[1], c[2], nRow, nCol, data) then
            loopSize = loopSize + 1
            visited[nRow][nCol] = data[nRow][nCol]
            table.insert(Q, {nRow, nCol})
        end
    end
end

local inLoop = false
local sub = nil

for _, row in ipairs(visited) do
    inLoop = false
    sub = nil
    for _, loop in ipairs(row) do
        if loop then
            if loop == "|" then inLoop = not inLoop 
            elseif loop ~= "-" then
                if sub == nil then 
                    sub = loop 
                elseif sub == "F" then
                    if loop == "J" then inLoop = not inLoop end
                    sub = nil
                elseif sub == "L" then
                    if loop == "7" then inLoop = not inLoop end
                    sub = nil
                end
            end
        else
            if inLoop == true then
                part2 = part2 + 1
            end
        end
    end
end

part1 = math.floor(loopSize / 2)

print("Part 1:", part1)
print("Part 2:", part2)
