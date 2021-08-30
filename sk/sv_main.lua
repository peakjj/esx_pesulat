ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
local PelaajaPesee = {}


local pesulat = {
    [1] = {
        pos = { x = 172.66, y = -1017.25, z = 29.38 }, 
        heading = 0.0,
        luotu = false --äläkoske
    }
}

RegisterNetEvent('karpo_pesulat:serverista')
AddEventHandler('karpo_pesulat:serverista', function()
    local _source = source
    TriggerClientEvent('karpo_pesulat:clienttiin', _source, pesulat)
end)


local function PesulaMAIN(source)
    local source = source 
    local poliiseja = 0 
    local xPlayers = ESX.GetPlayers()
    local xPlayer = ESX.GetPlayerFromId(source)
    local massit = xPlayer.getAccount('black_money')
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'police' then
                poliiseja = poliiseja + 1
        end
    end
        if poliiseja <= Config.kytat then
            TriggerClientEvent('esx:showNotification', source, "Poliiseja tarvitsee olla: ~b~" .. Config.kytat .. "~w~!")
            return
        end
        if massit.money >= Config.paljonpesee then
        local kuinkanopeesti = Config.kuinusein * 1000 --kertoo 1000, koska Timeout on ms eikä sekunteina. Eli tällä logiikalla 10 * 1000 = 10sec
        TriggerClientEvent('karpo_pesulat:pesutellaas', source)
        SetTimeout(kuinkanopeesti, function()
            if PelaajaPesee[source] == true then
                local xPlayer = ESX.GetPlayerFromId(source)
                local likaset = xPlayer.getAccount('black_money')
            
                if likaset.money < Config.paljonpesee then
                xPlayer.removeAccountMoney('black_money', likaset.money)
                xPlayer.addMoney(likaset.money)
                else
                    xPlayer.removeAccountMoney('black_money', 1000)
                    xPlayer.addMoney(Config.paljonantaa)
                    PesulaMAIN(source)
                end
                if likaset.money <= 0 then
                    TriggerClientEvent('karpo_pesulat:lopeta', source)
                    TriggerClientEvent('esx:showNotification', source, "Likaset loppu!")
                end
            end
        end)
    else
        TriggerClientEvent('karpo_pesulat:lopeta', source)
        TriggerClientEvent('esx:showNotification', source, "Tarvitset vähintään: ~g~$" ..Config.paljonpesee.. " ~w~pestäksesi!")
    end
end

RegisterServerEvent('karpo_pesulat:lopeta')
AddEventHandler('karpo_pesulat:lopeta', function()
	PelaajaPesee[source] = false
end)


RegisterServerEvent('karpo_pesulat:aloitus')
AddEventHandler('karpo_pesulat:aloitus', function()
	PelaajaPesee[source] = true
	PesulaMAIN(source)
end)
