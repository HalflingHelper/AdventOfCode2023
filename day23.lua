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

-- Just see how many open slots there are
local function adj2(data, pos)

    local adj = {}
    for _, v in pairs(slopes) do
        local c = { start[1] + v[1], start[2] + v[2] }
        if data[c[1]] and data[c[1]][c[2]] and data[c[1]][c[2]] ~= "#" then
            adj[#adj + 1] = c
        end
    end
    return adj
end

local function getNeighbors(data, n)
    local v = {}           -- visited
    local q = { { n, 0 } } -- queue with node and its distance from n

    local ns = {}          -- the thing that we want to return

    while #q ~= 0 do
        local cur = table.remove(q, 1)                  -- Pop an element from the queue

        local adj = adj2(data, cur[1])                  -- Find the squares next to our element

        if #adj ~= 2 and (hash(cur[1]) ~= hash(n)) then -- If there is not one neighbor, it is a terminal cell (So long as it is not where we started)
            local neigh = { table.unpack(cur) }
            neigh[3] = n                                -- We set up a table to add that includes the source node
            ns[#ns + 1] = neigh                         -- We add it to the result
        else                                            -- If there is only one of these, then we want to keep moving out, so we add it to the queue
            for i, o in ipairs(adj) do
                print(table.concat(o, ","))
                q[#q + 1] = { o, cur[2] + 1 } -- Increase the distance and add it back to the queue
            end
        end
    end

    return ns -- Return all of the neighbors, distances, and where they came from
end

local function bg(data, start, stop)
    -- bfs out from the start
    -- when we hit a node that has multiple choices we add it as a vertex
    local g = {}                         -- The graph (adjacency list)
    local v = {}                         -- The visited edges

    local ns = getNeighbors(data, start) -- Get the neighbors of the start

    while #ns ~= 0 do                    -- While there are still nodes to visit
        local n = table.remove(ns, 1)    -- Get an edge
        local h = hash(n[1]) .. "|" .. hash(n[3])

        if not v[h] then                                      -- If we haven't marked this edge
            v[h] = true                                       -- Mark the edge

            if not g[hash(n[3])] then g[hash(n[3])] = {} end  -- Make sure that we can put stuff in

            table.insert(g[hash(n[3])], { hash(n[1]), n[2] }) -- Add the edge to the graph for that neighbor

            local nss = getNeighbors(data, n[1])              -- Get all the neighbors for the node we just added

            for i, e in ipairs(nss) do
                ns[#ns + 1] = e -- Add each of those to our queue of edges to add to the graph
            end
        end
    end

    return g
end

local function bfs(data, start, stop)
    local v = {}
    local q = {{start, 0}}

    while #q ~= 0 do
        local cur = table.remove(q, 1)
        v[hash(cur[1])] = true
        if hash(cur[1]) == hash(stop) then
            return cur[2]
        end

        -- If it's interesting and not the goal, then we return -1
        if #adj2(data, cur[1]) ~= 2 and cur[1] ~= start then
        else

        for i, a in ipairs(getAdj(data, cur[1], v)) do
            table.insert(q, {a, cur[2] + 1})
        end
    end
    end

    return -1
end

local function bg2(data)
    local graph = {}

    local interesting = {}
    for i, row in ipairs(data) do
        for j, col in ipairs(row) do
            if col ~= "#" then
            local a = adj2(data, { i, j })
            if #a ~= 2 then
                interesting[#interesting + 1] = { i, j }
            end
        end end
    end

    for i, v in ipairs(interesting) do
        graph[hash(v)] = {}
        for j = i + 1, #interesting do
            local b = bfs(data, v, interesting[j])
            if b ~= -1 then
            table.insert(graph[hash(v)], { hash(interesting[j]), b })
            end
        end
    end
    print(graph[hash(start)])

    return graph
end

local function lp(graph, start, stop, visited)
    if start == stop then return 0 end

    visited[start] = true

    local res = 0

    print(start)
    for i, opt in ipairs(graph[start]) do
        if not visited[opt[1]] then
            local r = lp(graph, opt[1], stop, visited)
            -- if r == 0 then print(start, opt[2], "A") end
            r = r + opt[2]

            if r > res then
                res = r
            end
        end
    end

    visited[start] = false

    return res
end

-- Do everything else here
local g = bg2(d)
local part1 = lp(g, hash(start), hash(stop), {})




-- local g2 = bg(d2, start, stop)
-- local part2 = lp(g2, hash(start), hash(stop), {[hash(start)] = true})



print("Part 1:", part1)
print("Part 2:", part2)

-- High - 6681
