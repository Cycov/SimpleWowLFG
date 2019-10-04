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

function Quicko.Functions:FindIndex(items, value)
    local index
    for k,v in pairs(items) do
        if v == value then
            index = k
            return index
        end
    end
    return index
end

function Quicko.Functions:SetProprety(items, propName, propValue, exception)
    for k,v in pairs(items) do
        if v ~= exception then
            v[propName] = propValue
        end
    end
end
