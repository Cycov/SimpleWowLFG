if Quicko == nil then
    Quicko = {}
end

if Quicko.Functions == nil then
    Quicko.Functions = {}
end
--conditional, lua variant of c++'s "(condition)? true : false"
function Quicko.Functions:ternary(cond, T, F)
    if cond then return T else return F end
end

function Quicko.Functions:splitString(inputstr, separator)
    if separator == nil then
        separator = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^"..separator.."]+)") do
            table.insert(t, str)
    end
    return t
end
