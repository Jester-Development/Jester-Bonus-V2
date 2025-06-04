ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- UI status
local displayingMenu = false

-- Open Custom UI Menu
RegisterNetEvent('Jester-bonusV2:openMenu', function()
    if displayingMenu then return end
    
    displayingMenu = true
    SetNuiFocus(true, true)
    
    -- Send data to NUI
    SendNUIMessage({
        type = 'open',
        config = Config
    })
end)

-- NUI Callbacks
RegisterNUICallback('closeMenu', function(data, cb)
    displayingMenu = false
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('chooseReward', function(data, cb)
    displayingMenu = false
    SetNuiFocus(false, false)
    
    -- Trigger server event with chosen reward
    TriggerServerEvent('Jester-bonusV2:chooseReward', data.choice)
    cb('ok')
end)

-- Register key bindings (optional)
-- RegisterCommand('claim_menu', function()
--     TriggerEvent('Jester-bonusV2:openMenu')
-- end, false)

-- RegisterKeyMapping('claim_menu', 'Open claim menu', 'keyboard', 'F4')