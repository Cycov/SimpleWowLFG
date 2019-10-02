if Quicko == nil then
    Quicko = {}
end

if Quicko.Debug == nil then
    Quicko.Debug = {}
end

function Quicko.Debug:Log(input, levels, currentLevel)
    if levels == nil then
        levels = 0
    end

    if currentLevel == nil then
        currentLevel = 0
    end

    local count = 0    
    local levelPadding = ''
    for i=0,currentLevel - 1 do
        levelPadding = levelPadding .. '--'
    end

    if type(input) == 'table' then
        for k,v in pairs(input) do
            count = count + 1
            if currentLevel == levels then
                if type(v) == 'table' then
                    v = 'table'
                end
            end
            
            if type(v) == 'userdata' or
            type(v) == 'table' or
            type(v) == 'function' then
                v = type(v)
            end
            print(levelPadding .. '[' .. type(v) .. '] ' .. k .. ' = ' .. tostring(v))
            if currentLevel < levels then
                if type(v) == 'table' then
                    Quicko.Debug:Log(input, levels, currentLevel + 1)
                end
            end
        end
        if count == 0 then
            print('Debug:PrintTable() - Empty table')
        end        
    else
        print(input)
    end
end