require 'util'

DAY = 12

local filename = string.format("inputs/input_%02d.txt", DAY)

local f = assert(io.open(filename, "r"))

-- Function definitions here
local groups = {}
local numbers = {}

local memo = {} -- belongs to fitWays
local function fitWays(group, ns, j)
    j = j and j or 1
    local res = 0
    if j > #ns then 
        if group:match("#") then return 0 end
        return 1 
    end

    if not group or #group < sum(ns, j) + #ns - j then
        return 0
    end

    local h = j..group..table.concat(ns, ",")
    if memo[h] then
        return memo[h]
    end

    local n = ns[j]
    for i = 1, #group - n + 1 do
        local candidate = group:sub(i, i+n - 1)
        if not candidate:match("%.") and group:sub(i+n, i+n) ~= "#" then
            local w = fitWays(group:sub(i+n+1), ns, j+1)
            res = res + w
        end
        -- If we hit a "#" then it's the last possibility for a start index
        if group:sub(i, i) == "#" then break end
    end
    memo[h] = res
    return res
end

for line in f:lines() do
    -- Process the file here
    local partFlag = true
    for part in split(line, " ") do
        if partFlag then
            -- Groups
            groups[#groups+1] = part
            partFlag = false
        else
            -- Numbers
            local ns = {}
            for n in split(part, ",") do
                ns[#ns+1] = tonumber(n)
            end
            numbers[#numbers+1] = ns
        end
    end 
end

-- Do everything else here
local part1 = 0
local part2 = 0

for i = 1, #groups do
    local r = fitWays(groups[i], numbers[i])
    part1 = part1 + r

    local s = string.rep(groups[i], 5, "?"):gsub("[%.]+", ".")
    local r2 =  fitWays(s, table_rep(numbers[i], 5))
    part2 = part2 + r2
end

print("Part 1:", part1)
print("Part 2:", part2)
