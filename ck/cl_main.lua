ESX = nil
local pesulat = {}
local pesee = false
CreateThread(function()
    while ESX == nil do
        Wait(10)
        TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
    end
    Wait(500)
    TriggerServerEvent('karpo_pesulat:serverista')
    while true do
    Wait(2)
        for i=1, #pesulat, 1 do
            local kordinaatit = GetEntityCoords(PlayerPedId())
                if not pesee then
                    if Vdist(pesulat[i].pos.x,pesulat[i].pos.y,pesulat[i].pos.z, kordinaatit.x, kordinaatit.y, kordinaatit.z) < 3.0 then
                        Draw3DText2(pesulat[i].pos.x,pesulat[i].pos.y,pesulat[i].pos.z, tostring("~w~Paina ~g~E ~w~pestäksesi rahaa!"))
                        if IsControlJustPressed(0, 38) then
                            TriggerServerEvent('karpo_pesulat:aloitus')
                        end
                    end
                else
                    if Vdist(pesulat[i].pos.x,pesulat[i].pos.y,pesulat[i].pos.z, kordinaatit.x, kordinaatit.y, kordinaatit.z) < 3.0 then
                        Draw3DText2(pesulat[i].pos.x,pesulat[i].pos.y,pesulat[i].pos.z, tostring("~w~Paina ~r~X ~w~keskeyttääksesi pesu!"))  
                        if pesee then
                            if IsPedUsingAnyScenario(PlayerPedId()) == false then --jos pelaaja esim yrittää abusaa nii alottaa uudestaan animin
                                TaskStartScenarioInPlace(GetPlayerPed(-1), "CODE_HUMAN_MEDIC_TIME_OF_DEATH", -1, true);
                            end	
                            if IsControlPressed(0, 73) then
                                TriggerServerEvent('karpo_pesulat:lopeta')
                                pesee = false
                                ClearPedTasks(GetPlayerPed(-1))
                                ESX.ShowNotification('Pesu lopetettu!')
                            end
                        end
                    end
                end
                if not pesulat[i].luotu then
                    if Vdist(pesulat[i].pos.x, pesulat[i].pos.y, pesulat[i].pos.z, kordinaatit.x, kordinaatit.y, kordinaatit.z) < 150.0 then
                        local hash = GetHashKey("bkr_prop_prtmachine_dryer_spin")
                        RequestModel(hash)
                        while not HasModelLoaded(hash) do 
                            Wait(0) 
                        end
                        local object = CreateObject(hash, pesulat[i].pos.x, pesulat[i].pos.y, pesulat[i].pos.z,  false,  false,  false)
                        PlaceObjectOnGroundProperly(object)
                        SetEntityHeading(object, pesulat[i].heading)
                        FreezeEntityPosition(object, true)
                        pesulat[i].luotu = true
                    end
                end
            end

        end
end)

RegisterNetEvent('karpo_pesulat:clienttiin')
AddEventHandler('karpo_pesulat:clienttiin', function(infot)
    pesulat = infot
end)



RegisterNetEvent('karpo_pesulat:lopeta')
AddEventHandler('karpo_pesulat:lopeta', function()
    Citizen.Wait(100)
    pesee = false
    ClearPedTasks(GetPlayerPed(-1))
end)

RegisterNetEvent('karpo_pesulat:pesutellaas')
AddEventHandler('karpo_pesulat:pesutellaas', function()
    Citizen.Wait(100)
    pesee = true
end)

function Draw3DText2(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
    local scale = (1/dist)*1
    local fov = (1/GetGameplayCamFov())*100
    local scale = 1.0
   
    if onScreen then
        SetTextScale(0.0*scale, 0.25*scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(0, 0, 0, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    	DrawRect(_x,_y+0.0125, 0.013+ factor, 0.03, 0, 0, 0, 68)
    end
end
