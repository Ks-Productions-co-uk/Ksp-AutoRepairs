QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('Ksp-AutoRepairs:server:washCar')
AddEventHandler('Ksp-AutoRepairs:server:washCar', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.RemoveMoney('bank', Config.CarWashPrice) then
        TriggerClientEvent('Ksp-AutoRepairs:client:washCar', src)
    else
        TriggerClientEvent('QBCore:Notify', src, 'You don\'t have enough money for the car wash!', 'error')
    end
end)

RegisterServerEvent('Ksp-AutoRepairs:server:repairCar')
AddEventHandler('Ksp-AutoRepairs:server:repairCar', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.RemoveMoney('bank', Config.RepairPrice) then
        TriggerClientEvent('Ksp-AutoRepairs:client:repairCar', src)
    else
        TriggerClientEvent('QBCore:Notify', src, 'You don\'t have enough money for the repair!', 'error')
    end
end)
