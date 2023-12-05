DAY = 1

local filename = string.format("inputs/input_%02d.txt", DAY)

local f = assert(io.open(filename, "r"))

-- Function definitions here
local function subNums(t)
    local nums = { "one", "two", "three", "four", "five", "six", "seven", "eight", "nine" }

    local newStr = ""

    for i = 1, #t do
        if t:match("()%d", i) == i then
            newStr = newStr .. t:sub(i, i)
        else
            for j, v in ipairs(nums) do
                if t:match("()" .. v, i) == i then
                    newStr = newStr .. j
                    break
                end
            end
        end
    end

    return newStr
end

local part1_sum = 0
local part2_sum = 0

for line in f:lines() do
    -- Process the file here
    local nums = string.gsub(line, "%a", "")

    local n1 = nums:sub(1, 1)
    local n2 = nums:sub(#nums, #nums)

    part1_sum = part1_sum + tonumber(n1) * 10 + tonumber(n2)

    local nums = subNums(line)

    local n1 = nums:sub(1, 1)
    local n2 = nums:sub(#nums, #nums)

    part2_sum = part2_sum + tonumber(n1) * 10 + tonumber(n2)
end

-- Do everything else here
print("Part 1: ", part1_sum)
print("Part 2: ", part2_sum)
