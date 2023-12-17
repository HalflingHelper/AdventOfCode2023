require 'util'

DAY = 17

local filename = string.format("inputs/input_%02d.txt", DAY)

local f = assert(io.open(filename, "r"))

-- Function definitions here
local data = {}

local compMetatable = {} -- So that I can compare tables like tuples 💀
compMetatable.__eq = function(a, b) return a[1] == b[1] end
compMetatable.__lt = function(a, b) return a[1] < b[1] end
compMetatable.__le = function(a, b) return a[1] <= b[1] end

-- Djikstra-esque, hardcoding
local function findDistance(board, minDist, maxDist)
    local goal = #board .. "," .. #board[#board]
    
    local dirs = { u = { -1, 0 }, d = { 1, 0 }, l = { 0, -1 }, r = { 0, 1 } }
    local turns = { u = { "l", "r" }, d = { "l", "r" }, l = { "u", "d" }, r = { "u", "d" }, s = { "d", "r" } }

    local function hash(coord, dir)
        local dh = dir == "r" and "l" or dir == "u" and "d" or dir
        return coord[1] .. "," .. coord[2] .. dh
    end

    local paths = { ["1,1s"] = { weight = 0 } }
    local heap = { { 0, { 1, 1 }, "s" } }
    local certain = {}

    while #heap ~= 0 do
        local cur = removeHeap(heap)

        if cur[2][1] .. "," .. cur[2][2] == goal then return cur[1] end

        if certain[hash(cur[2], cur[3])] then
            goto continue
        end

        certain[hash(cur[2], cur[3])] = true

        for _, dir in ipairs(turns[cur[3]]) do
            local d = dirs[dir]
            local edgeWeight = 0
            local i, j = cur[2][1], cur[2][2]

            for q = 1, maxDist do
                if board[i + q * d[1]] and board[i + q * d[1]][j + q * d[2]] then
                    edgeWeight = edgeWeight + board[i + q * d[1]][j + q * d[2]]

                    if q >= minDist then
                        local newWeight = edgeWeight + cur[1]

                        local next = { i + q * d[1], j + q * d[2] }

                        local curPath = paths[hash(next, dir)]
                        local newPath = {}
                        newPath.weight = newWeight
                        if curPath == nil or newWeight < curPath.weight then
                            paths[hash(next, dir)] = newPath
                            insertHeap(heap, setmetatable({ newWeight, next, dir }, compMetatable))
                        end
                    end
                end
            end
        end
        ::continue::
    end
    return -1 -- Not Found
end

for line in f:lines() do
    -- Process the file here
    local row = {}
    for c in chars(line) do
        row[#row + 1] = tonumber(c)
    end
    data[#data + 1] = row
end

-- Do everything else here
local part1 = findDistance(data, 1, 3)
local part2 = findDistance(data, 4, 10)

print("Part 1:", part1)
print("Part 2:", part2)
