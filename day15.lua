require 'util'

DAY = 15

local filename = string.format("inputs/input_%02d.txt", DAY)

local f = assert(io.open(filename, "r"))

-- Function definitions here
local boxes = {}

local function hash(s)
    local cur = 0
    for c in chars(s) do
        local ascii = string.byte(c)
        cur = cur + ascii
        cur = cur * 17
        cur = cur % 256
    end
    return cur
end

local part1 = 0

for line in f:lines() do
    -- Process the file here
    for seq in split(line, ",") do
        -- Part 1
        local h = hash(seq)
        part1 = part1 + h

        -- Part 2
        local label, op, lens = seq:match("(%a+)([=-])(%d*)")
        local boxI = hash(label)
        if not boxes[boxI] then
            boxes[boxI] = {}
        end
        if op == "=" then
            local found = false
            for i, v in ipairs(boxes[boxI]) do
                if v[1] == label then
                    v[1] = label
                    v[2] = tonumber(lens)
                    found = true
                end
            end
            if not found then
                table.insert(boxes[boxI], {label, tonumber(lens)})
            end
        elseif op == "-" then
            for i, v in ipairs(boxes[boxI]) do
                if v[1] == label then
                    table.remove(boxes[boxI], i)
                    break
                end
            end
        end
    end
end

-- Do everything else here
local part2 = 0

for k, box in pairs(boxes) do
    for i, v in ipairs(box) do
        part2 = part2 + v[2] * i *(k + 1)
    end
end

print("Part 1:", part1)
print("Part 2:", part2)
