local QBCore = exports['qb-core']:GetCoreObject()
local Spawned = false
local box = nil

RegisterServerEvent('kg-cayo-airdrop:Respawn', function()
    if Spawned == true then return end

    Citizen.Wait(Config.RespawnTime)

    local loc = Config.Locations[math.random(1, #Config.Locations)]

    box = CreateObjectNoOffset(`gr_prop_gr_crates_sam_01a`, loc, true, true, false)

    Spawned = true
end)

RegisterNetEvent('kg-cayo-airdrop:Spawn', function()
    if Spawned == true then return end

    local loc = Config.Locations[math.random(1, #Config.Locations)]

    box = CreateObjectNoOffset(`gr_prop_gr_crates_sam_01a`, loc, true, true, false)

    Spawned = true
end)

RegisterServerEvent('kg-cayo-airdrop:GiveLoot', function()

    if Spawned == false then return end

    local Player = QBCore.Functions.GetPlayer(source)

    for i = 1, 3 do
        local item = Config.Items[math.random(1, #Config.Items)]
        Player.Functions.AddItem(item, 1)
        TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[item], "add", 1)
    end

    Spawned = false
    TriggerEvent('kg-cayo-airdrop:Respawn', source)
    TriggerClientEvent('kg-cayo-airdrop:SendMessageLocal', -1, "Alert", "Airdrop Has Been Stolen!!!")
end)

RegisterServerEvent('kg-cayo-airdrop:MessageBounce', function(message)
    TriggerClientEvent('kg-cayo-airdrop:SendMessageLocal', -1, "Alert", message)
end)

RegisterServerEvent('kg-cayo-airdrop:DeleteCrate', function(id)
    local ent = NetworkGetEntityFromNetworkId(id)
    DeleteEntity(ent)
end)

Citizen.CreateThread(function()
    print('Spawned Cayo AirDrop')
    TriggerEvent('kg-cayo-airdrop:Spawn')
end)