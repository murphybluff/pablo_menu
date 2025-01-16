local isBusy = false


local expectedResourceName = "pablo_menu"
local currentResourceName = GetCurrentResourceName()

if currentResourceName ~= expectedResourceName then
    print("Resource name mismatch! Expected: " .. expectedResourceName .. ", but got: " .. currentResourceName)
    return
end

function pablomenu(menuId, title, elements, callback)
    local menu = {
        id = menuId,
        title = title or menuId, 
        options = {}
    }

    for _, element in ipairs(elements) do
        local option = {
            title = element.title,
            icon = element.icon or nil,
            description = element.description or nil,
            disabled = element.unselectable or false,
            onSelect = function()
                if callback then
                    callback(menuId, element)
                end
            end
        }
        table.insert(menu.options, option)
    end

    lib.registerContext(menu)
    lib.showContext(menuId)
end

ESX.OpenContext = function(menuId, elements, callback)
    print("ESX.OpenContext called with menuId: " .. menuId) -- Debug log
    local title = elements[1] and elements[1].title or menuId
    pablomenu(menuId, title, elements, callback)
end