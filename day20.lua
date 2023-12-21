require 'util'

DAY = 20

local filename = string.format("inputs/input_%02d.txt", DAY)

local f = assert(io.open(filename, "r"))

-- Function definitions here
local modules = {}

for line in f:lines() do
    -- Process the file here
    local type = line:sub(1, 1)

    local outputs = split(line, ", ", line:find("-> ") + 3)

    local ot = {}
    for o in outputs do
        ot[#ot + 1] = o
    end

    if type == "%" then
        -- Flip-Flop
        local name = line:match("([%a]+) %->")

        local module = { outputs = ot, state = "off", inputs = {} }
        function module:process(from, sig)
            if sig == "low" then
                local outPulse

                if self.state == "off" then
                    -- Turn on and send out high pulses
                    self.state = "on"
                    outPulse = "high"
                else
                    -- Turn off and send out low pulses
                    self.state = "off"
                    outPulse = "low"
                end

                local res = {}
                for _, o in ipairs(self.outputs) do
                    res[#res + 1] = { o, outPulse, name }
                end
                return res
            elseif sig == "high" then
                return {}
            end
        end

        modules[name] = module
    elseif type == "&" then
        -- Conjuction
        local name = line:match("&([%a]+) %->")

        local module = { outputs = ot, inputs = {} }

        function module:process(from, sig)
            self.inputs[from] = sig

            local outPulse = "low"

            for _, v in pairs(self.inputs) do
                if v == "low" then
                    outPulse = "high"
                end
            end

            local res = {}
            for _, o in ipairs(self.outputs) do
                res[#res + 1] = { o, outPulse, name }
            end
            return res
        end

        modules[name] = module
    elseif type == "b" then
        -- Broadcaster - Just returns all of its outputs with the same signal, doesn't need state
        modules["broadcaster"] = {
            outputs = ot,
            inputs = {},
            process = function(self, from, sig)
                local res = {}
                for _, o in ipairs(self.outputs) do
                    res[#res + 1] = { o, sig, "broadcaster" }
                end
                return res
            end
        }
    end
end

for k, m in pairs(modules) do
    for _, o in ipairs(m.outputs) do
        if modules[o] then
            modules[o].inputs[k] = "low"
        end
    end
end

-- Do everything else here
local part1 = 0
local part2 = 0

local moduleQ = {}
local countHigh = 0
local countLow = 0

local function sendSignal(s)
    local m, type = modules[s[1]], s[2]

    if type == "low" then
        countLow = countLow + 1
    elseif type == "high" then
        countHigh = countHigh + 1
    end

    for i, v in ipairs(m:process(s[3], type)) do
        table.insert(moduleQ, v)
    end

    while #moduleQ > 0 do

        local cur = table.remove(moduleQ, 1)
        local m, type = modules[cur[1]], cur[2]

        if type == "low" then
            countLow = countLow + 1
        elseif type == "high" then
            countHigh = countHigh + 1
        end

        if m then
            for i, v in ipairs(m:process(cur[3], type)) do
                table.insert(moduleQ, v)
            end
        end
    end
end

for i = 1, 1000 do
    sendSignal({ "broadcaster", "low", "button" })
end
part1 = countHigh * countLow

part2 = math.floor(lcm(lcm(4021, 4013), lcm(3889, 3881)))

print("Part 1:", part1)
print("Part 2:", part2)
