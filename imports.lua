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
    local title = elements[1] and elements[1].title or menuId
    pablomenu(menuId, title, elements, callback)
end

local function pablomenuHAHA(menuData)
    local options = {}
    
    for _, item in ipairs(menuData) do
        if not item.hidden then
            local option = {
                title = item.header,
                description = item.txt or item.text,
                disabled = item.disabled,
                icon = item.icon,
            }
            
    
            if item.params then
                if item.params.event then
                    option.onSelect = function()
                        if item.params.isServer then
                            TriggerServerEvent(item.params.event, item.params.args)
                        elseif item.params.isCommand then
                            ExecuteCommand(item.params.event)
                        elseif item.params.isAction then
                            item.params.event(item.params.args)
                        else
                            TriggerEvent(item.params.event, item.params.args)
                        end
                    end
                end
            end
            
    
            if not item.isMenuHeader then
                table.insert(options, option)
            end
        end
    end
    
   
    lib.showContext({
        id = 'converted_menu',
        title = menuData[1]?.header or 'Menu', 
        options = options
    })
end


RegisterNetEvent('cfx-hu-menu:openMenu', function(data)
    if GetResourceState('ox_lib') == 'started' then
        exports['pablo_menu']:openMenu(data)
    else
        openMenu(data)
    end
end)

-- Export function to use pablomenuHAHA
exports('openMenu', function(menuData)
    pablomenuHAHA(menuData)
end)
