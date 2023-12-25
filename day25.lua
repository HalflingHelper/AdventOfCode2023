require 'util'

DAY = 25 -- We made it!

local filename = string.format("inputs/input_%02d.txt", DAY)

local f = assert(io.open(filename, "r"))

-- Function definitions here
local graph = {} -- An adjacency list
local graphSize = 0

-- Remvoes the edge from a to b in the graph g
local function rmEdge(g, a, b)
    for i, e in ipairs(g[a]) do
        if e == b then
            table.remove(g[a], i)
            break
        end
    end

    for i, e in ipairs(g[b]) do
        if e == a then
            table.remove(g[b], i)
            break
        end
    end
end

-- Not used but I'm leaving here for comopleteness
local function addEdge(g, a, b)
    table.insert(g[a], b)
    table.insert(g[b], a)
end

-- The number of nodes in the graph
local function size(g)
    local r = 0
    for _, _ in pairs(g) do r = r + 1 end
    return r
end

-- Returns a copy of the graph with the edge ab having been contracted (node a is kept)
local function edgeContract(graph, a, b)
    local g = { [a] = {} }

    for node, edges in pairs(graph) do
        if node == b then
            -- Add all the edges to a
            for i, e in ipairs(edges) do
                if e ~= a then
                    table.insert(g[a], e)
                end
            end
        elseif node == a then
            for i, e in ipairs(edges) do
                if e ~= b then
                    table.insert(g[a], e)
                end
            end
        else
            if not g[node] then g[node] = {} end
            for i, e in ipairs(edges) do
                if e == b then
                    table.insert(g[node], a)
                else
                    table.insert(g[node], e)
                end
            end
        end
    end

    return g
end

-- Returns a random edge from a graph of size s
local function randEdge(g, s)
    local r = math.random(s)
    local i = 1

    for n, edges in pairs(g) do
        if i == r then
            local n1 = n
            local n2 = edges[math.random(#edges)]

            return { n1, n2 }
        end
        i = i + 1
    end
end

-- Returns a set of all of the edges in graph g
local function allEdges(g)
    local r = {}
    for n, edges in pairs(g) do
        for i, v in ipairs(edges) do
            r[n..","..v] = true
        end
    end
    return r
end

local function contract(graph)
    -- Doing kargers
    local curG = graph
    local s = size(curG)

    local removedEdges = {}
    local merges = {}

    while s > 2 do
        local e = randEdge(curG, s)
        curG = edgeContract(curG, e[1], e[2])
        s = size(curG)

        -- Here I want to find the edges that were removed
        local grp1 = merges[e[1]] or {[e[1]]=true}
        local grp2 = merges[e[2]] or {[e[2]]=true}

        -- Mark the edges as removed
        for n1, _ in pairs(grp1) do
            for n2, _ in pairs(grp2) do
                removedEdges[#removedEdges+1] = {n1, n2}
                removedEdges[#removedEdges+1] = {n2, n1}
            end
        end
        -- Combine the groups
        for k, v in pairs(grp2) do 
            grp1[k] = true 
        end
        merges[e[2]] = nil
        merges[e[1]] = grp1

    end

    -- We're left with a graph with two vertices
    -- Get the size of the cut
    local res1, res2
    for k, v in pairs(curG) do
        res1 = k
        res2 = #v
        break
    end

    return res1, res2, removedEdges
end

local function getGroupSize(g, s)
    local visited = {[s] = true} -- Visited nodes
    local q = { s }
    local count = 0

    while #q ~= 0 do
        local cur = table.remove(q, 1)
        count = count + 1

        for i, v in ipairs(g[cur]) do
            if not visited[v] then
                visited[v] = true
                q[#q + 1] = v
            end
        end
    end

    return count
end

for line in f:lines() do
    -- Process the file here
    local node, edges = line:match("(...): (.+)")
    if not graph[node] then
        graph[node] = {}
        graphSize = graphSize + 1
    end

    for e in split(edges, " ") do
        if not graph[e] then
            graph[e] = {}
            graphSize = graphSize + 1
        end
        table.insert(graph[node], e)
        table.insert(graph[e], node)
    end
end

-- Do everything else here
local part1 = 0
local part2 = "snow!"

while true do
    local a, b, rmEdges = contract(graph)

    if b == 3 then
        local all = allEdges(graph)
        for i, v in ipairs(rmEdges) do
            all[v[1]..","..v[2]] = nil
            all[v[2]..","..v[1]] = nil
        end

        for k, v in pairs(all) do
            local x, y = k:match("(...),(...)")
            rmEdge(graph, x, y)
        end

        local grpSize = getGroupSize(graph, a)
        part1 = (graphSize - grpSize) * grpSize
        break
    end
end

print("Part 1:", part1)
print("Part 2:", part2)
