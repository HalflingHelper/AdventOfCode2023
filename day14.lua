require 'util'

DAY = 14

local filename = string.format("inputs/input_%02d.txt", DAY)

local f = assert(io.open(filename, "r"))

-- Function definitions here
local data = {}

local function spin(data)
    -- North, West, South, East
    -- N
    for col = 1, #data[1] do
        local flr = 1
        for row = 1, #data do
            local rock = data[row][col]
            if rock == "O" then
                data[row][col] = "."
                data[flr][col] = "O"
                flr = flr + 1
            elseif rock == "#" then
                flr = row + 1
            end
        end
    end
    -- W
    for row = 1, #data do
        local flr = 1
        for col = 1, #data[row] do
            local rock = data[row][col]
            if rock == "O" then
                data[row][col] = "."
                data[row][flr] = "O"
                flr = flr + 1
            elseif rock == "#" then
                flr = col + 1
            end
        end
    end
    --S
    for col = 1, #data[1] do
        local flr = #data
        for row = #data, 1, -1 do
            local rock = data[row][col]
            if rock == "O" then
                data[row][col] = "."
                data[flr][col] = "O"
                flr = flr - 1
            elseif rock == "#" then
                flr = row - 1
            end
        end
    end
    --E
    for row = 1, #data do
        local flr = #data[row]
        for col = #data[row], 1, -1 do
            local rock = data[row][col]
            if rock == "O" then
                data[row][col] = "."
                data[row][flr] = "O"
                flr = flr - 1
            elseif rock == "#" then
                flr = col - 1
            end
        end
    end
end

local function hash(data)
    local res = ""
    for i, v in ipairs(data) do
         for j, k in ipairs(v) do
            res = res .. k
         end
    end
    return res
end

local function unHash(str, w, h)
    local board = {}
    local row = 1
    local col = 1

    for c in chars(str) do
        if not board[row] then board[row] = {} end
        board[row][col] = c
        col = col + 1
        if col > w then
            col = 1
            row = row + 1
        end
    end

    return board
end

local function getNorthLoad(data)
    local res = 0
    local countRound = 0
    for col = 1, #data[1] do
        countRound = 0
        for row = #data, 1, -1 do
            local rock = data[row][col]
            if rock == "O" then
                countRound = countRound + 1
            elseif rock == "#" then
                if countRound ~= 0 then
                    local load = arithSum(#data - row - countRound + 1, #data - row)
                    res = res + load
                    countRound = 0
                end
            end
        end
        if countRound ~= 0 then
            local load = arithSum(#data - countRound + 1, #data)
            res = res + load
        end
    end
    return res
end

local function getLoad(data)
    local res = 0
    for d = #data, 1, -1 do
        for col = 1, #data do
            if data[#data - d + 1][col] == "O" then
                res = res + d
            end
        end
    end
    return res
end

for line in f:lines() do
    -- Process the file here
    local row = {}
    for c in chars(line) do
        row[#row + 1] = c
    end
    data[#data + 1] = row
end

-- Do everything else here
local part1 = 0
local part2 = 0

-- Work our way from the bottom to the top for each column
part1 = getNorthLoad(data)

-- Cycle detection
local cycle = {}
local next = {}

local h

for _ = 1,1000000000 do
    h = hash(data)

    if next[h] then
        break -- We found a cycle!!!!
    else
        spin(data)
        next[h] = hash(data)
        cycle[#cycle+1] = h
    end
end

-- Index of where the cycle starts
local start = 0
for i, v in ipairs(cycle) do
    if v == h then start = i end
end

-- How long the cycle is
local cLen = 0
local s = h
while true do
    cLen = cLen + 1
    h = next[h]
    if h == s then break end
end

local dataHash = cycle[start + (1000000000 - start) % cLen + 1]
part2 = getLoad(unHash(dataHash, #data[1], #data))

print("Part 1:", part1)
print("Part 2:", part2)
