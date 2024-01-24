local QBCore = exports['qb-core']:GetCoreObject()

local function SpawnCrate()
    local modelHash = `gr_prop_gr_crates_sam_01a`

    if not HasModelLoaded(modelHash) then
        RequestModel(modelHash)
        while not HasModelLoaded(modelHash) do
            Citizen.Wait(1)
        end
    end

    local loc = Config.Locations[math.random(1, #Config.Locations)]

    local obj = CreateObject(modelHash, loc.x, loc.y, loc.z, true, true, false)

    PlaceObjectOnGroundProperly(obj)

    TriggerServerEvent("kg-cayo-airdrop:SetSpawned", true)
end

RegisterNetEvent('kg-cayo-airdrop:LootCrate', function(entity)
    local ped = PlayerPedId()
    TriggerEvent('animations:client:EmoteCommandStart', {"mechanic"})
    TriggerServerEvent('kg-cayo-airdrop:MessageBounce', "Someone Has Found The Airdrop!!!")

    local time = 120000

    if Config.Debug == true then time = 5000 end

    QBCore.Functions.Progressbar('skin', 'Searching...', time, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true
        }, {}, {}, {}, function()
            TriggerServerEvent('kg-cayo-airdrop:GiveLoot')
            ClearPedTasks(ped)
            Wait(500)
            TriggerEvent('animations:client:EmoteCommandStart', {"c"})
            TriggerServerEvent('kg-cayo-airdrop:SetSpawned', false)
            TriggerServerEvent('kg-cayo-airdrop:DeleteCrate', NetworkGetNetworkIdFromEntity(entity))
        end, function()
            ClearPedTasks(ped)
            Wait(500)
            TriggerEvent('animations:client:EmoteCommandStart', {"c"})
    end)
end)

RegisterNetEvent('kg-cayo-airdrop:SpawnCrate', function()
    QBCore.Functions.TriggerCallback('kg-cayo-airdrop:IsCrateSpawned', function(result)
        if result == false then
            SpawnCrate()
        end
    end)
end)

RegisterNetEvent('kg-cayo-airdrop:SendMessageLocal', function(mtype, message)
    TriggerEvent('chat:addMessage', {
        color = { 255, 0, 0},
        multiline = true,
        args = {mtype, message}
      })
end)

Citizen.CreateThread(function()
    QBCore.Functions.TriggerCallback('kg-cayo-airdrop:IsCrateSpawned', function(result)
        if result == false then
            SpawnCrate()
        end
    end)

    exports['qb-target']:AddTargetModel("gr_prop_gr_crates_sam_01a", {
        options = {
        {
            type = "client",
            label = 'Loot Crate',
            action = function(entity) 
                if IsPedAPlayer(entity) then return false end
                TriggerEvent('kg-cayo-airdrop:LootCrate', entity)
            end,
        }
    },
        distance = 2.5,
    })
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end

    exports['qb-target']:RemoveTargetModel("gr_prop_gr_crates_sam_01a")
end)