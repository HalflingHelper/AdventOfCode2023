-- A Library of Utility functions that I build up over the course of the month

-- String Stuff
function split(string, char, init)
    init = init and init or 1
    return string:gmatch(("[^%s]+"):format(char), init)
end

function chars(string, init)
    init = init and init or 1
    return string:gmatch(".", init)
end

-- Math Stuff
function gcd(a, b)
    while (b > 0) do
        local temp = b
        b = a % b
        a = temp
    end
    return a
end

function lcm(a, b)
    return a * (b / gcd(a, b))
end

function sign(n)
    return n > 0 and 1 or -1
end

function sum(tbl, start)
    local s = 0
    for i = start, #tbl do
        s = s + tbl[i]
    end
    return s
end

-- Returns the sum of a .. b
function arithSum(a, b)
    return math.floor((a + b) / 2 * (b - a + 1))
end

-- Table stuff

-- Returns a table that is the contents of t repeated r times
function table_rep(tbl, r)
    local res = {}
    for i, v in ipairs(tbl) do
        for j = 0, r - 1 do
            res[i + j * #tbl] = v
        end
    end
    return res
end

-- Returns a table whos rows are the columns of tbl
function get_columns(tbl)
    local res = {}

    for i, row in ipairs(tbl) do
        local j = 1
        for c in chars(row) do
            if not res[j] then res[j] = "" end
            res[j] = res[j] .. c
            j = j + 1
        end
    end

    return res
end

function table_contains(table, val)
    for i, v in pairs(table) do
        if v == val then return true end
    end
    return false
end

-- Returns a copy of the array with duplicate entries removed
function table_remove_dupes(tbl)
    if #tbl == 0 then return tbl end

    local tmp = {}

    local i = 1
    while i <= #tbl do
        local v = tbl[i]
        if tmp[v] then
            table.remove(tbl, i)
            i = i -1
        end
        tmp[v] = true 

        i = i + 1 
    end
end

-- Stuff for a min heap
local function hLeft(n)
    return 2 * n
end

local function hRight(n)
    return 2 * n + 1
end

local function hParent(n)
    return math.floor(n / 2)
end

-- Swaps the elements of the table at indices a and b
local function swap(arr, a, b)
    local temp = arr[a]
    arr[a] = arr[b]
    arr[b] = temp
end

-- Moves the element at position i into the correct position
local function heapify(heap, i)
    local cLeft = heap[hLeft(i)]
    local cRight = heap[hRight(i)]

    if cLeft == nil and cRight == nil then
        return -- No kids
    elseif cRight == nil then
        if cLeft < heap[i] then
            swap(heap, i, hLeft(i))
            heapify(heap, hLeft(i))
        end
    elseif cLeft == nil then
        if cRight < heap[i] then
            swap(heap, i, hRight(i))
            heapify(heap, hRight(i))
        end
    else
        if cLeft < heap[i] or cRight < heap[i] then

        if cLeft < cRight then
            swap(heap, i, hLeft(i))
            heapify(heap, hLeft(i))
        else
            swap(heap, i, hRight(i))
            heapify(heap, hRight(i))
        end
    end
    end
end


function insertHeap(heap, val)
    local i = #heap + 1
    heap[i] = val

    while heap[hParent(i)] do
        heapify(heap, hParent(i))
        i = hParent(i)
    end
end

function removeHeap(heap)
    swap(heap, 1, #heap)
    local r=table.remove(heap, #heap)
    heapify(heap, 1)
    return r
end
