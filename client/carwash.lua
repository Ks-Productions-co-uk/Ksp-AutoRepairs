local QBCore = exports['qb-core']:GetCoreObject()
local washingVeh, repairingVeh, listen = false, false, false
local checkpoints = {}


local function washCar()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    local dirtLevel = GetVehicleDirtLevel(veh)
    if dirtLevel > Config.CarWash.dirtLevel then
        TriggerServerEvent('Ksp-AutoRepairs:server:washCar')
    else
        QBCore.Functions.Notify('The vehicle isn\'t dirty', 'error')
    end
end

local function repairCar()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)

    QBCore.Functions.Progressbar('repair_vehicle', 'Repairing vehicle...', math.random(8000, 15000), false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() 
        SetVehicleFixed(veh)
        SetVehicleDeformationFixed(veh)
        SetVehicleUndriveable(veh, false)
        repairingVeh = false
        ClearPedTasks(ped)
        QBCore.Functions.Notify('Repair completed successfully', 'success')
    end, function() 
        repairingVeh = false
        ClearPedTasks(ped)
        QBCore.Functions.Notify('Repair canceled', 'error')
    end)

    CreateThread(function()
        while repairingVeh do
            PlaySoundFrontend(-1, "Drill_Pin_Break", "DLC_HEIST_FLEECA_SOUNDSET", false)
            Wait(2000)
        end
    end)
end

RegisterNetEvent('Ksp-AutoRepairs:client:washCar', function()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    washingVeh = true
    QBCore.Functions.Progressbar('search_cabin', 'Vehicle is being washed...', math.random(4000, 8000), false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function()
        SetVehicleDirtLevel(veh, 0.0)
        WashDecalsFromVehicle(veh, 1.0)
        washingVeh = false
        QBCore.Functions.Notify('Washing completed successfully', 'success')
    end, function()
        QBCore.Functions.Notify('Washing canceled', 'error')
        washingVeh = false
    end)
end)

RegisterNetEvent('Ksp-AutoRepairs:client:repairCar', function()
    repairingVeh = true
    repairCar()
end)

local function showCarWashMenu()
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "openMenu",
        washPrice = Config.CarWashPrice,
        repairPrice = Config.RepairPrice
    })
end

local function closeCarWashMenu()
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = "closeMenu"
    })
end

local function showPrompt()
    SendNUIMessage({
        type = "showPrompt"
    })
end

local function hidePrompt()
    SendNUIMessage({
        type = "hidePrompt"
    })
end

CreateThread(function()
    while true do
        local sleep = 1000
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local isInAnyLocation = false

        for _, loc in pairs(Config.CarWash.locations) do
            local distance = #(playerCoords - vector3(loc.coords.x, loc.coords.y, loc.coords.z))
            if distance < loc.length then
                isInAnyLocation = true
                sleep = 0
                if IsPedInAnyVehicle(playerPed, false) then
                    showPrompt()
                    if IsControlJustReleased(0, 38) then  -- Using key 'E'
                        showCarWashMenu()
                        hidePrompt()
                    end
                else
                    hidePrompt()
                end
            end
        end

        if not isInAnyLocation then
            hidePrompt()
        end

        Wait(sleep)
    end
end)

RegisterNUICallback('washCar', function(data, cb)
    SetNuiFocus(false, false)
    closeCarWashMenu()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    local dirtLevel = GetVehicleDirtLevel(veh)
    if dirtLevel > Config.CarWash.dirtLevel then
        washCar()
    else
        QBCore.Functions.Notify('The vehicle isn\'t dirty', 'error')
    end
    cb('ok')
end)

RegisterNUICallback('repairCar', function(data, cb)
    SetNuiFocus(false, false)
    closeCarWashMenu()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    if veh ~= 0 then
        TriggerServerEvent('Ksp-AutoRepairs:server:repairCar')
    else
        QBCore.Functions.Notify('You are not in a vehicle', 'error')
    end
    cb('ok')
end)


RegisterNUICallback('repairCar', function(data, cb)
    SetNuiFocus(false, false)
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    if veh ~= 0 then
        TriggerServerEvent('Ksp-AutoRepairs:server:repairCar')
    else
        QBCore.Functions.Notify('You are not in a vehicle', 'error')
    end
    closeCarWashMenu()
    cb('ok')
end)

RegisterNUICallback('closeMenu', function(data, cb)
    closeCarWashMenu()
    cb('ok')
end)

CreateThread(function()
    while true do
        Wait(0)
        if IsControlJustReleased(0, 177) then -- 177 is the control code for the 'Esc' key
            closeCarWashMenu()
        end
    end
end)

CreateThread(function()
    for k, loc in pairs(Config.CarWash.locations) do
        local blip = AddBlipForCoord(loc.coords.x, loc.coords.y, loc.coords.z)
        SetBlipSprite(blip, 643)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.8)
        SetBlipAsShortRange(blip, true)
        SetBlipColour(blip, 55)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName('Ksp AutoRepairs')
        EndTextCommandSetBlipName(blip)
    end
end)
