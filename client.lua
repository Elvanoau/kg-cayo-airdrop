local QBCore = exports['qb-core']:GetCoreObject()
local obj = nil

RegisterNetEvent('kg-cayo-airdrop:LootCrate', function(entity)
    local ped = PlayerPedId()
    local pedPos = GetEntityCoords(ped)
    TriggerEvent('animations:client:EmoteCommandStart', {"mechanic"})
    TriggerServerEvent('kg-cayo-airdrop:MessageBounce', "Someone Has Found The Airdrop!!!")

    local time = 120000

    if Config.Debug == true then time = 5000 end

    AddExplosion(pedPos, 50, 0.0, true, false, 0.0)

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
            TriggerServerEvent('kg-cayo-airdrop:DeleteCrate', NetworkGetNetworkIdFromEntity(entity))
        end, function()
            ClearPedTasks(ped)
            Wait(500)
            TriggerEvent('animations:client:EmoteCommandStart', {"c"})
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
    if Config.Target == 'qb' then
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
    else
        local action = function(data)
            if IsPedAPlayer(data.entity) then return false end
            TriggerEvent('kg-cayo-airdrop:LootCrate', data.entity)
        end
    
        local options = {
            name = "cayo-loot-crate",
            label = "Loot Crate",
            onSelect = action,
            distance = 2.5,
        }

        exports.ox_target:addModel(`gr_prop_gr_crates_sam_01a`, options)
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end

    if Config.Target == 'qb' then
        exports['qb-target']:RemoveTargetModel("gr_prop_gr_crates_sam_01a")
    else
        exports.ox_target:removeModel(`gr_prop_gr_crates_sam_01a`)
    end
end)