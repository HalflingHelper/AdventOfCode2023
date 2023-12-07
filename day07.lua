require 'util'

DAY = 7

local filename = string.format("inputs/input_%02d.txt", DAY)

local f = assert(io.open(filename, "r"))

-- Function definitions here
local data = {}
local normalMap = { 'A', 'K', 'Q', 'J', 'T' }
local jokerMap = { 'A', 'K', 'Q', 'T', '9', '8', '7', '6', '5', '4', '3', '2', 'J' }

local function type(hand)
    local tbl = {}
    for c in chars(hand) do
        if tbl[c] then
            tbl[c] = tbl[c] + 1
        else
            tbl[c] = 1
        end
    end

    local found3 = false
    local found2 = false

    for char, count in pairs(tbl) do
        if count == 5 then return 7 end
        if count == 4 then return 6 end
        if count == 3 then
            if found2 then return 5 end
            found3 = true
        end
        if count == 2 then
            if found3 then return 5 end
            if found2 then return 3 end
            found2 = true
        end
    end

    if found3 then return 4 end
    if found2 then return 2 end

    return 1
end

local function greaterCard(a, b, map)
    for _, f in ipairs(map) do
        if a == f then return b ~= f end
        if b == f then return false end
    end

    return a > b
end

local function compareHands(a, b)
    -- Returns true when A >= B
    local tA = type(a)
    local tB = type(b)

    if tA > tB then return true end
    if tB > tA then return false end

    for i = 1, 5 do
        local cA = a:sub(i, i)
        local cB = b:sub(i, i)

        if greaterCard(cA, cB, normalMap) then return true end
        if greaterCard(cB, cA, normalMap) then return false end
    end
    -- The hands are equal
    return true
end

local function typeWithJokers(hand)
    local best = 1

    for _, f in ipairs(jokerMap) do
        if string.find(hand, f) ~= nil then
            local h = string.gsub(hand, 'J', f)
            best = math.max(best, type(h))
        end
    end

    return best
end


local function compareWithJokers(a, b)
    -- Returns true when A >= B
    local tA = typeWithJokers(a)
    local tB = typeWithJokers(b)

    if tA > tB then return true end
    if tB > tA then return false end

    for i = 1, 5 do
        local cA = a:sub(i, i)
        local cB = b:sub(i, i)

        if greaterCard(cA, cB, jokerMap) then return true end
        if greaterCard(cB, cA, jokerMap) then return false end
    end
    -- The hands are equal
    return true
end
for line in f:lines() do
    -- Process the file here
    local row = {}
    for s in split(line, " ") do
        if #s == 5 then
            row[1] = s
        else
            row[2] = tonumber(s)
        end
    end

    data[#data + 1] = row
end

-- Do everything else here
local part1 = 0
local part2 = 0


table.sort(data, function(a, b) return not compareHands(a[1], b[1]) end)

for i, v in ipairs(data) do
    part1 = part1 + v[2] * i
end

table.sort(data, function(a, b) return not compareWithJokers(a[1], b[1]) end)

for i, v in ipairs(data) do
    part2 = part2 + v[2] * i
end

print("Part 1:", part1)
print("Part 2:", part2)
