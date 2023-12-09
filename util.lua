-- A Library of Utility functions that I build up over the course of the month

function split(string, char, init)
    init = init and init or 1
    return string:gmatch(("[^%s]+"):format(char), init)
end

function chars(string, init)
    init = init and init or 1
    return string:gmatch(".", init)
end

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