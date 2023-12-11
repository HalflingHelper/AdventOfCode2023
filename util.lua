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
    return a * (b/gcd(a, b))
end

function sign(n)
    return n > 0 and 1 or -1
end