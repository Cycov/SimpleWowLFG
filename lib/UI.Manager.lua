if Quicko == nil then
    Quicko = {}
end

if Quicko.UI == nil then
    Quicko.UI = {}
end

if Quicko.UI.Manager == nil then
    Quicko.UI.Manager = {}
    Quicko.UI.Manager.__index = Quicko.UI.Manager

    setmetatable(Quicko.UI.Manager, {
      __call = function (cls, ...)
        return cls.new(...)
      end,
    })

    function Quicko.UI.Manager.new()
        return setmetatable({}, Quicko.UI.Manager)
    end

    function Quicko.UI.Manager:AddWindow(window)
        if Quicko.UI.Manager.windows == nil then
            Quicko.UI.Manager.windows = {}
        end
        table.insert(Quicko.UI.Manager.windows, window)
    end

    function Quicko.UI.Manager:OnInit(...)
        for index,window in pairs(Quicko.UI.Manager.windows) do
            window:OnInit(...)
        end
    end

    function Quicko.UI.Manager:OnLoad(...)
        for index,window in pairs(Quicko.UI.Manager.windows) do
            window:OnLoad(...)
        end
    end

    function Quicko.UI.Manager:OnEvent(event, ...)
        for index,window in pairs(Quicko.UI.Manager.windows) do
            window:OnEvent(event, ...)
        end
    end
end
