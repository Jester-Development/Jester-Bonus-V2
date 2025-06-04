ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Command voor claimen
RegisterCommand('claim', function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local identifier = xPlayer.identifier

    -- Controleer of de speler al heeft geclaimd
    exports.oxmysql:query('SELECT claimed FROM claims WHERE identifier = ?', {identifier}, function(result)
        if result[1] and result[1].claimed then
            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 0, 0},
                multiline = true,
                args = {"Beloning", "Je hebt je beloning al opgehaald!"}
            })
            return
        end

        -- Open het menu voor de speler
        TriggerClientEvent('Jester-bonusV2:openMenu', source)
    end)
end, false)

-- Verwerk de keuze van de speler
RegisterNetEvent('Jester-bonusV2:chooseReward', function(choiceValue)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local identifier = xPlayer.identifier

    -- Controleer of de speler al heeft geclaimd
    exports.oxmysql:query('SELECT claimed FROM claims WHERE identifier = ?', {identifier}, function(result)
        if result[1] and result[1].claimed then
            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 0, 0},
                multiline = true,
                args = {"Beloning", "Je hebt je beloning al opgehaald!"}
            })
            return
        end

        -- Zoek de gekozen beloning in de config
        local chosenReward = nil
        for _, reward in ipairs(Config.RewardOptions) do
            if reward.value == choiceValue then
                chosenReward = reward
                break
            end
        end

        if not chosenReward then
            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 0, 0},
                multiline = true,
                args = {"Beloning", "Ongeldige beloning gekozen!"}
            })
            return
        end

        -- Verwerk de beloning op basis van type
        if chosenReward.type == 'money' then
            -- Voeg geld toe aan de speler
            xPlayer.addMoney(chosenReward.amount)
            TriggerClientEvent('chat:addMessage', source, {
                color = {0, 255, 0},
                multiline = true,
                args = {"Beloning", "Je hebt " .. chosenReward.amount .. " ontvangen in cash!"}
            })
        elseif chosenReward.items then
            -- Voeg items toe aan inventaris
            for _, item in ipairs(chosenReward.items) do
                if string.match(item.name, "weapon_") then
                    xPlayer.addInventoryItem(item.name, item.amount)
                else
                    xPlayer.addInventoryItem(item.name, item.amount)
                end
            end
            TriggerClientEvent('chat:addMessage', source, {
                color = {0, 255, 0},
                multiline = true,
                args = {"Beloning", "Je hebt " .. chosenReward.label .. " ontvangen!"}
            })
        end

        -- Zet in de database dat de beloning is geclaimd
        exports.oxmysql:execute('INSERT INTO claims (identifier, claimed) VALUES (?, ?) ON DUPLICATE KEY UPDATE claimed = 1', {identifier, 1})
    end)
end)

-- Maak de database bij resource start
AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end

    exports.oxmysql:execute([[
        CREATE TABLE IF NOT EXISTS claims (
            identifier VARCHAR(50) NOT NULL PRIMARY KEY,
            claimed BOOLEAN NOT NULL DEFAULT 0
        )
    ]])
end)