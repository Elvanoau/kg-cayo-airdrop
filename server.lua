local QBCore = exports['qb-core']:GetCoreObject()
local Spawned = false

RegisterServerEvent('kg-cayo-airdrop:SetSpawned', function(bool)
    Spawned = bool
end)

RegisterServerEvent('kg-cayo-airdrop:Respawn', function(src)
    if Spawned == true then return end

    local player = src

    Citizen.Wait(300000)

    TriggerClientEvent('kg-cayo-airdrop:SpawnCrate', player)

end)

RegisterServerEvent('kg-cayo-airdrop:GiveLoot', function()

    if Spawned == false then return end

    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    for i = 1, 3 do
        local item = Config.Items[math.random(1, #Config.Items)]
        Player.Functions.AddItem(item, 1)
        TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[item], "add", 1)
    end

    Spawned = false
    TriggerEvent('kg-cayo-airdrop:Respawn', src)
    TriggerClientEvent('kg-cayo-airdrop:SendMessageLocal', -1, "Alert", "Airdrop Has Been Stolen!!!")
end)

RegisterServerEvent('kg-cayo-airdrop:MessageBounce', function(message)
    TriggerClientEvent('kg-cayo-airdrop:SendMessageLocal', -1, "Alert", message)
end)

RegisterServerEvent('kg-cayo-airdrop:DeleteCrate', function(id)
    local ent = NetworkGetEntityFromNetworkId(id)
    DeleteEntity(ent)
end)

QBCore.Functions.CreateCallback('kg-cayo-airdrop:IsCrateSpawned', function(source, cb)
    cb(Spawned)
end)