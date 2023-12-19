require 'util'

DAY = 19

local filename = string.format("inputs/input_%02d.txt", DAY)

local f = assert(io.open(filename, "r"))

-- Function definitions here
local workflows = {} -- Each workflow is a list of rules
local parts = {}

-- Returns true or false if the part is accepted or rejected
local function getNext(part, workflow)
    for i, f in ipairs(workflow) do
        if f.f(part[f.eval]) then
            return f.dest
        end
    end
    return "FAIL"
end

local function process(part)
    local cur = "in"

    while cur ~= "A" and cur ~= "R" do
        cur = getNext(part, workflows[cur])
    end

    return cur == "A"
end

local function rating(part)
    return part.x + part.m + part.a + part.s
end

local function getPossible(bounds)
    local res = 1
    for _, v in pairs(bounds) do
        if v.high < v.low then return 0 end
        res = res * (v.high - v.low + 1)
    end
    return res
end

local function copyBounds(b)
    return {
        x = { low = b.x.low, high = b.x.high },
        m = { low = b.m.low, high = b.m.high },
        a = { low = b.a.low, high = b.a.high },
        s = { low = b.s.low, high = b.s.high }
    }
end

local function numValid(wf, bounds)
    if getPossible(bounds) == 0 then
        return 0
    end

    bounds = copyBounds(bounds)
    local res = 0

    for i, rule in ipairs(wf) do
        if rule.eval == nil then
            if rule.dest == "A" then
                return res + getPossible(bounds)
            elseif rule.dest == "R" then
                return res
            else
                return res + numValid(workflows[rule.dest], bounds)
            end
        end

        -- Rule is valid
        -- Figure out the intersection of our bounds and the validity bounds
        -- Do a recursive call for that intersection and rule.next
        if rule.f(rule.bad + 1) then
            local t = bounds[rule.eval].low
            bounds[rule.eval].low = rule.bad + 1

            if rule.dest == "A" then
                res = res + getPossible(bounds)
            elseif rule.dest ~= "R" then
                res = res + numValid(workflows[rule.dest], bounds)
            end

            bounds[rule.eval].low = t
            bounds[rule.eval].high = rule.bad
        else
            local t = bounds[rule.eval].high
            bounds[rule.eval].high = rule.bad - 1

            if rule.dest == "A" then
                res = res + getPossible(bounds)
            elseif rule.dest ~= "R" then
                res = res + numValid(workflows[rule.dest], bounds)
            end

            bounds[rule.eval].high = t
            bounds[rule.eval].low = rule.bad
        end
        -- Rule isn't valid: Update the bounds, and move to next rule
    end
    return res -- Unreachable
end

local flag = false
for line in f:lines() do
    -- Process the file here
    if #line == 0 then
        flag = true
    elseif flag then -- parts
        local x, m, a, s = line:match("{x=(%d+),m=(%d+),a=(%d+),s=(%d+)}")
        parts[#parts + 1] = { x = tonumber(x), m = tonumber(m), a = tonumber(a), s = tonumber(s) }
    else -- workflows
        local wf = {}
        local name, rules = line:match("(%a+){(.+)}")

        for rule in split(rules, ",") do
            local prop, op, mark, nxt = rule:match("(%a)([<>])(%d+):(%a+)")
            if op == nil then
                wf[#wf + 1] = { f = function(part) return true end, dest = rule }
            elseif op == "<" then
                wf[#wf + 1] = {
                    f = function(n) return n < tonumber(mark) end,
                    dest = nxt,
                    bad = tonumber(mark),
                    eval = prop
                }
            elseif op == ">" then
                wf[#wf + 1] = {
                    f = function(n) return n > tonumber(mark) end,
                    dest = nxt,
                    bad = tonumber(mark),
                    eval = prop
                }
            end
        end
        workflows[name] = wf
    end
end

-- Do everything else here
local part1 = 0
local part2 = 0

for _, v in ipairs(parts) do
    if process(v) then
        part1 = part1 + rating(v)
    end
end

part2 = numValid(workflows["in"],
    {
        x = { low = 1, high = 4000 },
        m = { low = 1, high = 4000 },
        a = { low = 1, high = 4000 },
        s = { low = 1, high = 4000 }
    })


print("Part 1:", part1)
print("Part 2:", part2)
