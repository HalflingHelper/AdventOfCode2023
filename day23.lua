require 'util'

DAY = 23

local filename = string.format("inputs/input_%02d.txt", DAY)

local f = assert(io.open(filename, "r"))

-- Function definitions here
local d = {}
local d2 = {}
local slopes = { ["<"] = { 0, -1 }, [">"] = { 0, 1 }, ["^"] = { -1, 0 }, ["v"] = { 1, 0 } }

for line in f:lines() do
    -- Process the file here
    local row = {}
    local row2 = {}
    for c in chars(line) do
        row[#row + 1] = c
        row2[#row2 + 1] = c == "#" and "#" or "."
    end
    d[#d + 1] = row
    d2[#d2 + 1] = row2
end

local start = { 1, 2 }
local stop  = { #d, #d[#d] - 1 }

local function hash(pos)
    return pos[1] * 147 + pos[2]
end

local function unhash(h)
    return math.floor(h / 147) .. "," .. (h % 147)
end

local function getAdj(data, start, visited)
    local slope = slopes[data[start[1]][start[2]]]
    if slope then return { { start[1] + slope[1], start[2] + slope[2] } } end

    local adj = {}
    for _, v in pairs(slopes) do
        local c = { start[1] + v[1], start[2] + v[2] }
        if data[c[1]] and data[c[1]][c[2]] and data[c[1]][c[2]] ~= "#" and not visited[hash(c)] then
            adj[#adj + 1] = c
        end
    end
    return adj
end

local function findI(data, pos, v)
    local dist = 1
    local adj = getAdj(data, pos, v)
    local cur = pos

    while #adj == 1 do
        dist = dist + 1
        v[hash(cur)] = true
        cur = adj[1]
        adj = getAdj(data, cur, v)
    end

    return { cur, dist, pos }
end

local function gn(data, pos)
    local a = getAdj(data, pos, {})

    local r = {}

    for _, adj in ipairs(a) do
        r[#r + 1] = findI(data, adj, { [hash(pos)] = true })
        r[#r][3] = pos
    end
    return r
end

local function bg(data, start, stop)
    -- bfs out from the start
    -- when we hit a node that has multiple choices we add it as a vertex
    local g = {}                      -- The graph (adjacency list)
    local v = {}                      -- The visited edges

    -- TODO: This will break if there are multiple paths between two nodes
    -- because you're not guaranteed to build the longest one first.
    -- This wasn't in the input so I'm fine, but this should be a heap to make sure
    -- you add the longest edges first to the graph
    local ns = gn(data, start)        -- Get the neighbors of the start

    while #ns ~= 0 do                 -- While there are still nodes to visit
        local n = table.remove(ns, 1) -- Get an edge
        local h = hash(n[1]) .. "|" .. hash(n[3])

        if not v[h] then                                      -- If we haven't marked this edge
            v[h] = true                                       -- Mark the edge

            if not g[hash(n[3])] then g[hash(n[3])] = {} end  -- Make sure that we can put stuff in

            table.insert(g[hash(n[3])], { hash(n[1]), n[2] }) -- Add the edge to the graph for that neighbor

            local nss = gn(data, n[1])                        -- Get all the neighbors for the node we just added

            for i, e in ipairs(nss) do
                ns[#ns + 1] = e -- Add each of those to our queue of edges to add to the graph
            end
        end
    end

    return g
end

-- Do everything else here
local g = bg(d, start)
local part1 = lp(g, hash(start), hash(stop), {})

local g2 = bg(d2, start, stop)
local part2 = lp(g2, hash(start), hash(stop), { [hash(start)] = true })

print("Part 1:", part1)
print("Part 2:", part2)
