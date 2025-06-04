Config = {}

Config.RewardOptions = {
    {
        label = '400k Contant',
        value = 'money',
        image = 'nui/images/money.png',
        description = 'Ontvang 400.000 contant geld',
        amount = 400000,
        type = 'money'
    },
    {
        label = 'M1911 + 200 Ammo',
        value = 'weapon',
        image = 'nui/images/m1911.png',
        description = 'Ontvang een M1911 pistool met 200 kogels',
        items = {
            {name = 'weapon_m1911', amount = 1},
            {name = 'ammo-9', amount = 200}
        }
    }
    -- Voeg hier meer beloningen toe indien nodig
}

-- UI Instellingen
Config.UI = {
    position = 'right', -- 'right' of 'left'
    title = 'Kies je beloning',
    titleColor = 'rgb(255, 215, 0)'
}