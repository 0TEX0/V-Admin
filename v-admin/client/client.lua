ESX = {};

TriggerEvent('OTEXO&KraKss:esx:getSharedObject', function(obj)
    ESX = obj
end)

local gamertag = {
    ["user"] = "Joueurs",
    ["help"] = "Helpeur",
    ["mod"] = "Modo",
    ["admin"] = "Admin",
    ["superadmin"] = "Gérant Staff",
    ["owner"] = "Gérant Staff",
    ["_dev"] = "Fondateur",
}

local Listing = {}
local player = {};
local jobs = nil
local lisenceontheflux = nil
local Bot = {}
local get = false
local onStaffMode = false

function KeyboardInput(entryTitle, textEntry, inputText, maxLength)
	AddTextEntry(entryTitle, textEntry)
	DisplayOnscreenKeyboard(1, entryTitle, '', inputText, '', '', '', maxLength)

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(850)
	end

	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		return result
	else
		Citizen.Wait(850)
		return nil
	end
end

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        player = ESX.GetPlayerData()
        Citizen.Wait(850)
    end
end)

local TempsValue = ""
local raisontosend = "Aucune Raison !"
local GroupItem = {}
GroupItem.Value = 1

local mainMenu = RageUI.CreateMenu("~w~Administration", "~b~Gestions du serveur", 0);
local inventoryMenu = RageUI.CreateSubMenu(mainMenu, "~w~Administration", "Inventaire du joueur", 0)
inventoryMenu:DisplayGlare(true)

local TARGET_INVENTORY = {}

mainMenu:DisplayPageCounter(false)
mainMenu:DisplayGlare(true)
mainMenu:AddInstructionButton({
    [1] = GetControlInstructionalButton(1, 334, 0),
    [2] = "Modifier la vitesse du NoClip",
});

local selectedMenu = RageUI.CreateSubMenu(mainMenu, "~w~Administration", "placeholder")
selectedMenu:DisplayGlare(true)

local playerActionMenu = RageUI.CreateSubMenu(mainMenu, "~w~Administration", "placeholder")
playerActionMenu:DisplayGlare(true)

local adminmenu = RageUI.CreateSubMenu(mainMenu, "~w~Administration", "Menu Admin")
adminmenu:DisplayGlare(true)

local utilsmenu = RageUI.CreateSubMenu(mainMenu, "~w~Administration", "Menu Utils")
utilsmenu:DisplayGlare(true)

local moneymenu = RageUI.CreateSubMenu(mainMenu, "~w~Administration", "Menu Give")
moneymenu:DisplayGlare(true)

local tpmenu = RageUI.CreateSubMenu(mainMenu, "~w~Administration", "Menu Teleportation")
tpmenu:DisplayGlare(true)

local vehiculemenu = RageUI.CreateSubMenu(mainMenu, "~w~Administration", "Menu Vehicule")
vehiculemenu:DisplayGlare(true)

local menugive = RageUI.CreateSubMenu(mainMenu, "~w~Administration", "Menu give")
menugive:DisplayGlare(true)

local customCols = RageUI.CreateSubMenu(vehiculemenu, "~w~Menu Couleurs", "Couleurs")
customCols:DisplayGlare(true)

local customNeon = RageUI.CreateSubMenu(vehiculemenu, "~w~Menu Neon", "Neon")
customNeon:DisplayGlare(true)

local reportmenu = RageUI.CreateSubMenu(mainMenu, "~w~Administration", "Liste Report")
reportmenu:DisplayGlare(true)

---@class OTEXO
OTEXO = {} or {};

---@class SelfPlayer Administrator current settings
OTEXO.SelfPlayer = {
    ped = 0,
    isStaffEnabled = false,
    isClipping = false,
    isGamerTagEnabled = false,
    isReportEnabled = true,
    isInvisible = false,
    isCarParticleEnabled = false,
    isSteve = false,
    isDelgunEnabled = false,
};

OTEXO.SelectedPlayer = {};

OTEXO.Menus = {} or {};

OTEXO.Helper = {} or {}

---@class Players
OTEXO.Players = {} or {} --- Players lists
---
OTEXO.PlayersStaff = {} or {} --- Players Staff

OTEXO.AllReport = {} or {} --- Players Staff


---@class GamerTags
OTEXO.GamerTags = {} or {};

playerActionMenu.onClosed = function()
    OTEXO.SelectedPlayer = {};
    lisenceontheflux = nil;
end

local NoClip = {
    Camera = nil,
    Speed = 1.0
}

local oldpos = nil
local specatetarget = nil
local specateactive = false

function spectate(target)
    if not oldpos then
        TriggerServerEvent("OTEXO:teleport", target)
        oldpos = GetEntityCoords(GetPlayerPed(PlayerId()))
		SetEntityVisible(GetPlayerPed(PlayerId()), false)
        SetEntityCollision(GetPlayerPed(PlayerId()), false, false)
        specatetarget = target
        specateactive = true
    else
        SetEntityCoords(GetPlayerPed(PlayerId()), oldpos.x, oldpos.y, oldpos.z)
        SetEntityVisible(GetPlayerPed(PlayerId()), true)
        SetEntityCollision(GetPlayerPed(PlayerId()), true, true)
        specatetarget = nil
        gang = ""
        oldpos = nil
        specateactive = false
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if specateactive then
            for _, player in ipairs(GetActivePlayers()) do
                if GetPlayerServerId(player) == tonumber(specatetarget) then
                    local ped = GetPlayerPed(player)
                    local coords = GetEntityCoords(ped)
                    SetEntityNoCollisionEntity(GetPlayerPed(PlayerId()), ped, true)
                    SetEntityCoords(GetPlayerPed(PlayerId()), coords.x, coords.y, coords.z)
                end
            end             
        end            
    end
end)

local selectedIndex = 0;

local FastTravel = {
    { Name = "~g~Parking central~s~", Value = vector3(215.76, -810.8, 30.72) },
    { Name = "~g~Fourrière~s~", Value = vector3(409.16, -1625.47, 29.29) },
    { Name = "~g~Concessionaire~s~", Value = vector3(-67.6, -1091.21, 26.63) },
    { Name = "~g~Mécano~s~", Value = vector3(-211.44, -1323.68, 30.89) },
    { Name = "~g~Cayo Perico~s~", Value = vector3(4509.66, -4508.96, 3.01) },
}

local GroupIndex = 1;
local GroupIndexx = 1;
local GroupIndexxx = 1;
local GroupIndexxxx = 1;
local GroupIndexxxxx = 1;
local GroupIndexxxxxWeapon = 1;
local GroupIndexxxxxPed = 1;
local IndexJobs = 1;
local IndexJobsGrade = 1;
local IndexGangs = 1;
local IndexGangsGrade = 1;
local PermissionIndex = 1;
local VehicleIndex = 1;
local ColorIndex = 1;
local FastTravelIndex = 1;
local CarParticleIndex = 1;
local idtosanctionbaby = 1;
local idtoreport = 1;
local kvdureport = 1;
local colorMetalList = 1;
local colorList = 1;
local colorNeon = 1;



function OTEXO.Helper:RetrievePlayersDataByID(source)
    local player = {};
    for i, v in pairs(OTEXO.Players) do
        if (v.source == source) then
            player = v;
        end
    end
    return player;
end




function OTEXO.Helper:onToggleNoClip(toggle)
    if (toggle) then
        ESX.ShowNotification("~g~Vous venez d'activer le noclip")
        if (ESX.GetPlayerData()['group'] ~= "user") then
            if (NoClip.Camera == nil) then
                NoClip.Camera = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
            end
            SetCamActive(NoClip.Camera, true)
            RenderScriptCams(true, false, 0, true, true)
            SetCamCoord(NoClip.Camera, GetEntityCoords(OTEXO.SelfPlayer.ped))
            SetCamRot(NoClip.Camera, GetEntityRotation(OTEXO.SelfPlayer.ped))
            SetEntityCollision(NoClip.Camera, false, false)
            SetEntityVisible(NoClip.Camera, false)
            SetEntityVisible(OTEXO.SelfPlayer.ped, false, false)
        end
    else
        if (ESX.GetPlayerData()['group'] ~= "user") then
            ESX.ShowNotification("~r~Vous venez de désactiver le noclip")
            SetCamActive(NoClip.Camera, false)
            RenderScriptCams(false, false, 0, true, true)
            SetEntityCollision(OTEXO.SelfPlayer.ped, true, true)
            SetEntityCoords(OTEXO.SelfPlayer.ped, GetCamCoord(NoClip.Camera))
            SetEntityHeading(OTEXO.SelfPlayer.ped, GetGameplayCamRelativeHeading(NoClip.Camera))
            if not (OTEXO.SelfPlayer.isInvisible) then
                SetEntityVisible(OTEXO.SelfPlayer.ped, true, false)
            end
        end
    end
end

RegisterNetEvent("OTEXO:envoyer")
AddEventHandler("OTEXO:envoyer", function(msg)
    ESX.ShowNotification('- ~r~Message du Staff~s~\n- '..msg)
    PlaySoundFrontend(-1, "CHARACTER_SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
end)

function OTEXO.Helper:OnRequestGamerTags()
    for _, player in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(player)
        if (OTEXO.GamerTags[ped] == nil) or (OTEXO.GamerTags[ped].ped == nil) or not (IsMpGamerTagActive(OTEXO.GamerTags[ped].tags)) then
            local formatted;
            local group = 0;
            local permission = 0;
            local fetching = OTEXO.Helper:RetrievePlayersDataByID(GetPlayerServerId(player));
            if fetching.group ~= nil then
                if fetching.group ~= "user" then
                    formatted = string.format('[' .. gamertag[fetching.group] .. '] %s | %s [%s]', GetPlayerName(player), GetPlayerServerId(player),fetching.jobs)
                else
                    formatted = string.format('[%d] %s [%s]', GetPlayerServerId(player), GetPlayerName(player), fetching.jobs)
                end
            else
                formatted = string.format('[%d] %s [%s]', GetPlayerServerId(player), GetPlayerName(player), "Jobs Unknow")
            end
            if (fetching) then
                group = fetching.group
                permission = fetching.permission
            end

            OTEXO.GamerTags[ped] = {
                player = player,
                ped = ped,
                group = group,
                permission = permission,
                tags = CreateFakeMpGamerTag(ped, formatted)
            };
        end

    end
end


function RefreshPlayerGroup()
    Citizen.CreateThread(function()
        ESX.TriggerServerCallback('OTEXO:getUsergroup', function(group)
            playergroup = group
        end)   
    end)
end


function OTEXO.Helper:RequestPtfx(assetName)
    RequestNamedPtfxAsset(assetName)
    if not (HasNamedPtfxAssetLoaded(assetName)) then
        while not HasNamedPtfxAssetLoaded(assetName) do
            Citizen.Wait(1.0)
        end
        return assetName;
    else
        return assetName;
    end
end

function OTEXO.Helper:CreateVehicle(model, vector3)
    self:RequestModel(model)
    local vehicle = CreateVehicle(model, vector3, 100.0, true, false)
    local id = NetworkGetNetworkIdFromEntity(vehicle)

    SetNetworkIdCanMigrate(id, true)
    SetEntityAsMissionEntity(vehicle, false, false)
    SetModelAsNoLongerNeeded(model)

    SetVehicleHasBeenOwnedByPlayer(vehicle, true)
    SetVehicleOnGroundProperly(vehicle)
    SetVehicleNeedsToBeHotwired(vehicle, false)
    SetVehRadioStation(vehicle, 'OFF')
    while not HasCollisionLoadedAroundEntity(vehicle) do
        Citizen.Wait(500)
    end
    return vehicle, GetEntityCoords(vehicle);
end

function OTEXO.Helper:OnGetPlayers()
    local clientPlayers = false;
    ESX.TriggerServerCallback('OTEXO:retrievePlayers', function(players)
        clientPlayers = players
    end)

    while not clientPlayers do
        Citizen.Wait(0)
    end
    return clientPlayers
end

function OTEXO.Helper:OnGetStaffPlayers()
    local clientPlayers = false;
    ESX.TriggerServerCallback('OTEXO:retrieveStaffPlayers', function(players)
        clientPlayers = players
    end)
    while not clientPlayers do
        Citizen.Wait(0)
    end
    return clientPlayers
end

function OTEXO.Helper:GetReport()
    ESX.TriggerServerCallback('OTEXO:retrieveReport', function(allreport)
        ReportBB = allreport
    end)
    while not ReportBB do
        Citizen.Wait(500)
    end
    return ReportBB
end

function admin_vehicle_flip()

    local player = GetPlayerPed(-1)
    posdepmenu = GetEntityCoords(player)
    carTargetDep = GetClosestVehicle(posdepmenu['x'], posdepmenu['y'], posdepmenu['z'], 10.0,0,70)
    if carTargetDep ~= nil then
            platecarTargetDep = GetVehicleNumberPlateText(carTargetDep)
    end
    local playerCoords = GetEntityCoords(GetPlayerPed(-1))
    playerCoords = playerCoords + vector3(0, 2, 0)
    
    SetEntityCoords(carTargetDep, playerCoords)
    
    ESX.ShowAdvancedNotification('Administration', '~r~Informations', 'Le ~r~véhicule~s~ a été retourné', 'CHAR_SUNLITE', 2)

end

RegisterNetEvent("OTEXO:RefreshReport")
AddEventHandler("OTEXO:RefreshReport", function()
    OTEXO.GetReport = OTEXO.Helper:GetReport()
end)

function OTEXO.Helper:onStaffMode(status)
    if (status) then
        onStaffMode = true
        CreateThread(function()
            while onStaffMode do
                Visual.Subtitle("Nom : ~b~"..GetPlayerName(PlayerId()).."~s~ | Report actuels : ~b~" .. #OTEXO.GetReport , 999999999999999)
                Citizen.Wait(1000)
            end
        end)
        OTEXO.PlayersStaff = OTEXO.Helper:OnGetStaffPlayers()
        OTEXO.GetReport = OTEXO.Helper:GetReport()
    else
        onStaffMode = false
        Visual.Subtitle("Report actifs : ~r~" .. #OTEXO.GetReport , 1)
        if (OTEXO.SelfPlayer.isClipping) then
            OTEXO.Helper:onToggleNoClip(false)
        end
        if (OTEXO.SelfPlayer.isInvisible) then
            OTEXO.SelfPlayer.isInvisible = false;
            SetEntityVisible(OTEXO.SelfPlayer.ped, true, false)
        end
    end
    
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        if (OTEXO.SelfPlayer.isStaffEnabled) then
            OTEXO.Players = OTEXO.Helper:OnGetPlayers()
            OTEXO.PlayersStaff = OTEXO.Helper:OnGetStaffPlayers()
            OTEXO.GetReport = OTEXO.Helper:GetReport()
        end
    end
end)

local ped = {
    { Name = "Pogo 1", Value = 'u_m_m_streetart_01' },
    { Name = "Pogo 2", Value = 'u_m_y_pogo_01' },
    { Name = "Mime", Value = 's_m_y_mime' },
    { Name = "Jesus", Value = 'u_m_m_jesus_01' },
    { Name = "Zombie", Value = 'u_m_y_zombie_01' },
    { Name = "The Rock", Value = 'u_m_y_babyd' },
}
local pedIndex = 1
local ValuePed = 'u_m_m_streetart_01'
local NamePed = 'Pogo 1'

RegisterNetEvent("OTEXO:noclipkey")
AddEventHandler("OTEXO:noclipkey", function()
    RefreshPlayerGroup()
    if (OTEXO.SelfPlayer.isStaffEnabled) then
        if (OTEXO.SelfPlayer.isClipping) then
            OTEXO.Helper:onToggleNoClip(false)
            OTEXO.SelfPlayer.isClipping = false
        else
            OTEXO.Helper:onToggleNoClip(true)
            OTEXO.SelfPlayer.isClipping = true 
        end
    else
        ESX.ShowNotification("~r~Active le mode Staff")
    end
    print("Presse Key - F3")
end)

RegisterNetEvent("OTEXO:menu1")
AddEventHandler("OTEXO:menu1", function()
    RefreshPlayerGroup()
    OTEXO.Players = OTEXO.Helper:OnGetPlayers();
    OTEXO.PlayersStaff = OTEXO.Helper:OnGetStaffPlayers()
    OTEXO.GetReport = OTEXO.Helper:GetReport()
    RageUI.Visible(mainMenu, not RageUI.Visible(mainMenu))
    print("Presse Key - F10")
end)

RegisterNetEvent("OTEXO:menu2")
AddEventHandler("OTEXO:menu2", function()
    RefreshPlayerGroup()
    OTEXO.GetReport = OTEXO.Helper:GetReport()
    RageUI.Visible(reportmenu, not RageUI.Visible(reportmenu))
    print("Presse Key - F11")
end)



Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)

        if (IsControlJustPressed(0, Config.Touche.Noclip)) then --F3
            TriggerServerEvent("OTEXO:noclipkey")
        end

        if (IsControlJustPressed(0, Config.Touche.Menu)) then
            TriggerServerEvent("OTEXO:ouvrirmenu1")
        end

        if (IsControlJustPressed(0, Config.Touche.MenuReport)) then
            TriggerServerEvent("OTEXO:ouvrirmenu2")
        end

        RageUI.IsVisible(mainMenu, function()

            RageUI.Separator("Joueurs : ~b~" .. #OTEXO.Players.. "~s~ | Staff en ligne : ~b~" .. #OTEXO.PlayersStaff .. "")
            if onStaffMode == false then
            RageUI.Separator("Report actifs : ~b~" ..#OTEXO.GetReport)

            RageUI.Line(52, 235, 235, 200)

            RageUI.List('choisissez votre Ped', ped, pedIndex, nil, {}, true, {
                
                onListChange = function(Index, Item)
                    pedIndex = Index;
                    ValuePed = Item.Value
                    NamePed = Item.Name
                end,
            })
            end

            RageUI.Separator('Ped : ~b~'.. NamePed)

            RageUI.Checkbox("Prendre son service", "Le mode staff ne peut être utilisé que pour modérer le serveur, tout abus sera sévèrement puni, l'intégralité de vos actions sera enregistrée.", OTEXO.SelfPlayer.isStaffEnabled, { }, {
                onChecked = function()
                    PlaySoundFrontend(-1, "Hack_Success", "DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS", 1)
                    OTEXO.Helper:onStaffMode(true)
                    TriggerServerEvent('OTEXO:onStaffJoin')
                    local j1 = PlayerId(-1)
                    local p1 = GetHashKey(ValuePed)
                    RequestModel(p1)
                    while not HasModelLoaded(p1) do
                        Wait(100)
                    end 
                        SetPlayerModel(j1, p1)
                        SetModelAsNoLongerNeeded(p1)
                end,
                onUnChecked = function()
                    PlaySoundFrontend(-1, "Click", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1)
                    OTEXO.Helper:onStaffMode(false)
                    TriggerServerEvent('OTEXO:onStaffLeave')
                    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                        local isMale = skin.sex == 0
                        TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
                            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                                TriggerEvent('skinchanger:loadSkin', skin)
                                TriggerEvent('esx:restoreLoadout')
                            end)
                        end)
                    end) 
                end,
                onSelected = function(Index)
                    OTEXO.SelfPlayer.isStaffEnabled = Index
                end
            })
            

            if (OTEXO.SelfPlayer.isStaffEnabled) then

                RageUI.Line(52, 235, 235, 200)

                RageUI.Button('Intéractions Joueurs', nil, { RightLabel = "~b~→→" }, true, {
                    onSelected = function()
                        selectedMenu:SetSubtitle(string.format('Joueurs en lignes [%s]', #OTEXO.Players))
                        selectedIndex = 1;
                    end
                }, selectedMenu)

                RageUI.Button('Report en attente', nil, { RightLabel = '~b~'..#OTEXO.GetReport }, true, {
                    onSelected = function()
                    end
                }, reportmenu)

                RageUI.Line(52, 235, 235, 200)


                RageUI.Checkbox("Caméra Libre", "Vous permet de vous déplacer librement sur toute la carte sous forme de caméra libre.", OTEXO.SelfPlayer.isClipping, { }, {
                    onChecked = function()
                    TriggerServerEvent("OTEXO:SendLogs", "Active noclip")
                    OTEXO.Helper:onToggleNoClip(true)
                    end,
                    onUnChecked = function()
                    TriggerServerEvent("OTEXO:SendLogs", "Désactive noclip")
                    OTEXO.Helper:onToggleNoClip(false)
                    end,
                    onSelected = function(Index)
                    OTEXO.SelfPlayer.isClipping = Index
                    end
                }, selectedMenu)

                RageUI.Checkbox("Afficher les Noms", "L'affichage des tags des joueurs vous permet de voir les informations des joueurs, y compris de vous reconnaître entre les membres du personnel grâce à votre couleur.", OTEXO.SelfPlayer.isGamerTagEnabled, { }, {
                    onChecked = function()
                    if (ESX.GetPlayerData()['group'] ~= "user") then
                    TriggerServerEvent("OTEXO:SendLogs", "Active GamerTags")
                    OTEXO.Helper:OnRequestGamerTags()
                    end
                    end,
                    onUnChecked = function()
                    for i, v in pairs(OTEXO.GamerTags) do
                    TriggerServerEvent("OTEXO:SendLogs", "Désactive GamerTags")
                    RemoveMpGamerTag(v.tags)
                    end
                    OTEXO.GamerTags = {};
                    end,
                    onSelected = function(Index)
                    OTEXO.SelfPlayer.isGamerTagEnabled = Index
                    end
                }, selectedMenu)

                RageUI.Checkbox("Mode Invisible", nil, OTEXO.SelfPlayer.isInvisible, { }, {
                    onChecked = function()
                    TriggerServerEvent("OTEXO:SendLogs", "Active invisible")
                    SetEntityVisible(OTEXO.SelfPlayer.ped, false, false)
                    end,
                    onUnChecked = function()
                    TriggerServerEvent("OTEXO:SendLogs", "Désactive invisible")
                    SetEntityVisible(OTEXO.SelfPlayer.ped, true, false)
                    end,
                    onSelected = function(Index)
                        OTEXO.SelfPlayer.isInvisible = Index
                    end
                })

                RageUI.Line(52, 235, 235, 200)

                RageUI.Button('Réparation du véhicule', nil, { }, true, {
                    onSelected = function()
                        local plyVeh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                        SetVehicleFixed(plyVeh)
                        SetVehicleDirtLevel(plyVeh, 0.0)
                        ESX.ShowAdvancedNotification('Administration', '~r~Informations', 'Le ~r~véhicule~s~ a été réparé', 'CHAR_SUNLITE', 2)
                        TriggerServerEvent("OTEXO:SendLogs", "Repair Vehicle")
                    end
                })

                local gang = ""
                if specateactive then
                    gang = "✅"
                end    
                RageUI.Button('Spectate Aléatoire', nil, { RightLabel = gang }, true, {
                    onSelected = function()
                        local number = #OTEXO.Players
                        local target = OTEXO.Players[math.random(0~number)].source
                        if target == GetPlayerServerId(PlayerId()) then
                            ESX.ShowNotification("Votre ID a été sélectionné mais vous ne pouvez pas vous spec vous même ! Réessayer !")
                        else
                            spectate(target)
                        end
                    end
                }) 

                RageUI.Line(52, 235, 235, 200)

                RageUI.Button('Practics', nil, { RightLabel = "~b~→→" }, true, {
                    onSelected = function()
                    end
                }, tpmenu)

                RageUI.Button('Véhicules', nil, { RightLabel = "~b~→→" }, true, {
                    onSelected = function()
                    end
                }, vehiculemenu)

                if playergroup ~= nil and ( playergroup == '_dev' or playergroup == 'owner' or playergroup == 'superadmin' or playergroup == 'admin') then
                    RageUI.Button('System', nil, { RightLabel = "~b~→→" }, true, {
                        onSelected = function()
                        end
                    }, utilsmenu)
                end
                
                if playergroup ~= nil and ( playergroup == '_dev' or playergroup == 'owner' or playergroup == 'superadmin') then
                    RageUI.Button('Menu give', nil, { RightLabel = "~b~→→" }, true, {
                        onSelected = function()
                        end
                    }, menugive)
                end

            end
        end)

        if (OTEXO.SelfPlayer.isStaffEnabled) then
            RageUI.IsVisible(inventoryMenu, function()
                for i, v in pairs(TARGET_INVENTORY) do
                    RageUI.Button(v.label, nil, { RightLabel = v.count }, true, {
                        onSelected = function()
        
                        end
                    })
                end
            end)
        end


        if (OTEXO.SelfPlayer.isStaffEnabled) then
            RageUI.IsVisible(tpmenu, function()

            RageUI.Button('TP sur point', 'Permet de se ~r~téléporter~s~ sur un ~r~point~s~', { RightLabel = gang }, true, {
                onSelected = function()
                    plyPed = PlayerPedId()
                    local waypointHandle = GetFirstBlipInfoId(8)

                    if DoesBlipExist(waypointHandle) then
                        Citizen.CreateThread(function()
                            local waypointCoords = GetBlipInfoIdCoord(waypointHandle)
                            local foundGround, zCoords, zPos = false, -500.0, 0.0
        
                            while not foundGround do
                                zCoords = zCoords + 10.0
                                RequestCollisionAtCoord(waypointCoords.x, waypointCoords.y, zCoords)
                                Citizen.Wait(0)
                                foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords.x, waypointCoords.y, zCoords)
        
                                if not foundGround and zCoords >= 2000.0 then
                                    foundGround = true
                                end
                            end
        
                            SetPedCoordsKeepVehicle(plyPed, waypointCoords.x, waypointCoords.y, zPos)
                            ESX.ShowNotification("Vous avez été TP")
                            TriggerServerEvent("OTEXO:SendLogs", "Se TP sur le waypoint")
                        end)
                    else
                        ESX.ShowNotification("Pas de marqueur sur la carte")
                    end
                end
            })

            RageUI.List('TP sur ', FastTravel, FastTravelIndex, nil, {}, true, {
                onListChange = function(Index, Item)
                FastTravelIndex = Index;
                end,
                onSelected = function(Index, Item)
                SetEntityCoords(PlayerPedId(), Item.Value)
                TriggerServerEvent("OTEXO:SendLogs", "Utilise le fast travel")
                end
            })
        end)
    end

        if (OTEXO.SelfPlayer.isStaffEnabled) then
            RageUI.IsVisible(utilsmenu, function()

                RageUI.Checkbox("Coordonnées", "Affiche les ~o~coordonnées", OTEXO.SelfPlayer.ShowCoords, { }, {
                    onChecked = function()
                        TriggerServerEvent("OTEXO:SendLogs", "Affiche les coordonnées")
                        coords = true
                    end,
                    onUnChecked = function()
                        TriggerServerEvent("OTEXO:SendLogs", "Désactive l'affichage des coordonnées")
                        coords = false
                    end,
                    onSelected = function(Index)
                        OTEXO.SelfPlayer.ShowCoords = Index
                    end
                })

                RageUI.Checkbox("Delgun", 'Active le ~g~pistolet~s~ qui ~r~delete', OTEXO.SelfPlayer.isDelgunEnabled, { }, {
                    onChecked = function()
                        TriggerServerEvent("OTEXO:SendLogs", "Active Delgun")
                    end,
                    onUnChecked = function()
                        TriggerServerEvent("OTEXO:SendLogs", "Désactive Delgun")
                    end,
                    onSelected = function(Index)
                        OTEXO.SelfPlayer.isDelgunEnabled = Index
                    end
                })

            end)
        end

        if (OTEXO.SelfPlayer.isStaffEnabled) then
            RageUI.IsVisible(menugive, function()

                RageUI.Button("S'octroyer de ~g~l'argent en liquide", nil, { RightLabel = "→" }, true, {
                    onSelected = function()
                        local amount = KeyboardInput('OTEXO_BOX_AMOUNT', "Veuillez entrer la somme", '', 8)

                        if amount ~= nil then
                            amount = tonumber(amount)
                
                            if type(amount) == 'number' then
                                TriggerServerEvent('OTEXO:GiveMoney', "money", amount)   
                                ESX.ShowNotification("Give de ~g~" .. amount .. "$~s~")                            
                            end
                        end
                    end,
                })

                RageUI.Button("S'octroyer de ~b~l'argent en banque", nil, { RightLabel = "→" }, true, {
                    onSelected = function()
                        local amount = KeyboardInput('OTEXO_BOX_AMOUNT', "Veuillez entrer la somme", '', 8)

                        if amount ~= nil then
                            amount = tonumber(amount)
                
                            if type(amount) == 'number' then
                                TriggerServerEvent('OTEXO:GiveMoney', "bank", amount)  
                                ESX.ShowNotification("Give de ~b~" .. amount .. "$~s~")                             
                            end
                        end
                    end,
                })

                RageUI.Button("S'octroyer de ~r~l'argent en sale", nil, { RightLabel = "→" }, true, {
                    onSelected = function()
                        local amount = KeyboardInput('OTEXO_BOX_AMOUNT', "Veuillez entrer la somme", '', 8)

                        if amount ~= nil then
                            amount = tonumber(amount)
                
                            if type(amount) == 'number' then
                                TriggerServerEvent('OTEXO:GiveMoney', "black_money", amount)  
                                ESX.ShowNotification("Give de ~r~" .. amount .. "$~s~")                             
                            end
                        end
                    end,
                })

            end)
        end

        if (OTEXO.SelfPlayer.isStaffEnabled) then
            RageUI.IsVisible(vehiculemenu, function()
                RageUI.List('Véhicules', {
                    { Name = "Véhicule personnalisée", Value = nil },
                    { Name = "BMX", Value = 'bmx' },
                    { Name = "Sanchez", Value = 'sanchez' },
                    { Name = "Blista", Value = "blista" },
                }, VehicleIndex, nil, {}, true, {
                    onListChange = function(Index, Item)
                        VehicleIndex = Index;
                    end,
                    onSelected = function(Index, Item)
                        if Item.Value == nil then
                            local modelName = KeyboardInput('OTEXO_BOX_VEHICLE_NAME', "Veuillez entrer le ~r~nom~s~ du véhicule", '', 50)
                            TriggerEvent('OTEXO:spawnVehicle', modelName)
                            TriggerServerEvent("OTEXO:SendLogs", "Spawn custom vehicle")
                        else
                            TriggerEvent('OTEXO:spawnVehicle', Item.Value)
                            TriggerServerEvent("OTEXO:SendLogs", "Spawn vehicle")
                        end
                    end,
                })
                RageUI.Button('~g~Réparation~s~ du véhicule', nil, { }, true, {
                    onSelected = function()
                        local plyVeh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                        SetVehicleFixed(plyVeh)
                        SetVehicleDirtLevel(plyVeh, 0.0)
                        ESX.ShowAdvancedNotification('Administration', '~r~Informations', 'Le ~r~véhicule~s~ a été réparé', 'CHAR_SUNLITE', 2)
                        TriggerServerEvent("OTEXO:SendLogs", "Repair Vehicle")
                    end
                })

                RageUI.Button("~b~Retourner~s~ le véhicule", nil, {RightLabel = ""}, true, {
                    onSelected = function()
                        admin_vehicle_flip()
                    end
                })

                RageUI.List('~r~Suppression~s~ des véhicules (Zone)', {
                    { Name = "1", Value = 1 },
                    { Name = "5", Value = 5 },
                    { Name = "10", Value = 10 },
                    { Name = "15", Value = 15 },
                    { Name = "20", Value = 20 },
                    { Name = "25", Value = 25 },
                    { Name = "30", Value = 30 },
                    { Name = "50", Value = 50 },
                    { Name = "100", Value = 100 },
                    { Name = "MAP", Value = 100000 },
                }, GroupIndex, nil, {}, true, {
                    onListChange = function(Index, Item)
                        GroupIndex = Index;
                    end,
                    onSelected = function(Index, Item)
                        TriggerServerEvent("OTEXO:SendLogs", "Delete vehicle zone")
                        ESX.ShowAdvancedNotification('Administration', '~r~Informations', 'La ~r~suppression~s~ a été effectué', 'CHAR_SUNLITE', 2)
                        local playerPed = PlayerPedId()
                        local radius = Item.Value
                        if radius and tonumber(radius) then
                            radius = tonumber(radius) + 0.01
                            local vehicles = ESX.Game.GetVehiclesInArea(GetEntityCoords(playerPed, false), radius)

                            for i = 1, #vehicles, 1 do
                                local attempt = 0

                                while not NetworkHasControlOfEntity(vehicles[i]) and attempt < 100 and DoesEntityExist(vehicles[i]) do
                                    Citizen.Wait(500)
                                    NetworkRequestControlOfEntity(vehicles[i])
                                    attempt = attempt + 1
                                end

                                if DoesEntityExist(vehicles[i]) and NetworkHasControlOfEntity(vehicles[i]) then
                                    ESX.Game.DeleteVehicle(vehicles[i])
                                    DeleteEntity(vehicles[i])
                                end
                            end
                        else
                            local vehicle, attempt = ESX.Game.GetVehicleInDirection(), 0

                            if IsPedInAnyVehicle(playerPed, true) then
                                vehicle = GetVehiclePedIsIn(playerPed, false)
                            end

                            while not NetworkHasControlOfEntity(vehicle) and attempt < 100 and DoesEntityExist(vehicle) do
                                Citizen.Wait(500)
                                NetworkRequestControlOfEntity(vehicle)
                                attempt = attempt + 1
                            end

                            if DoesEntityExist(vehicle) and NetworkHasControlOfEntity(vehicle) then
                                ESX.Game.DeleteVehicle(vehicle)
                                DeleteEntity(vehicle)
                            end
                        end
                    end,
                })

                RageUI.Button('~r~Changer~s~ la plaque', nil, {}, true, {
                    onSelected = function()
                        if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
                            local plaqueVehicule = KeyboardInput('OTEXO_PLAQUE_NAME',"Veuillez entrer le ~r~nom~s~ de la plaque", "", 8)
                            SetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false) , plaqueVehicule)
                            ESX.ShowAdvancedNotification('Administration', '~r~Informations', 'Le nom de la plaque est désormais : ~r~' ..plaqueVehicule, 'CHAR_SUNLITE', 2)
                        else
                            ESX.ShowAdvancedNotification('Administration', '~r~Informations', '~r~Erreur :~s~ Vous n\'êtes pas dans un véhicule ~r~', 'CHAR_SUNLITE', 2)
                        end
                    end
                })

                RageUI.Line(52, 235, 235, 200)

                RageUI.Button("Couleurs", nil, { RightLabel = "~b~→→" }, true, {
                    onSelected = function()
                end}, customCols) 
        
                RageUI.Button("Neon", nil, { RightLabel = "~b~→→" }, true, {
                    onSelected = function()
                end}, customNeon)  

            end)
        end

        RageUI.IsVisible(customCols, function()
            RageUI.Separator("~b~↓~s~ Chrome ~b~↓")
                RageUI.Button("Chromé", nil, {}, true, {
                    onSelected = function()
                        local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                        SetVehicleColours(vehicle, 120, 120)
                end})
                RageUI.Button("Gold", nil, {}, true, {
                    onSelected = function()
                        local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                        SetVehicleColours(vehicle, 99, 99)
                end})
                RageUI.Button("Silver", nil, {}, true, {
                    onSelected = function()
                        local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                        SetVehicleColours(vehicle, 4, 4)
                end})
                RageUI.Button("Bronze", nil, {}, true, {
                    onSelected = function()
                        local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                        SetVehicleColours(vehicle, 90, 90)
                end})
                RageUI.Separator("~b~↓~s~ Classiques ~b~↓")
                Listing.ColorMetalList = {
                    { Name = "Black Steel", Value1 = 2, Value2 = 2 },
                    { Name = "Dark Steel", Value1 = 3, Value2 = 3 }, 
                    { Name = "Red", Value1 = 27, Value2 = 27 },
                    { Name = "Grace Red", Value1 = 31, Value2 = 31 },
                    { Name = "Sunset Red", Value1 = 33, Value2 = 33 },
                    { Name = "Wine Red", Value1 = 143, Value2 = 143 },
                    { Name = "Hot Pink", Value1 = 135, Value2 = 135 },
                    { Name = "Pfsiter Pink", Value1 = 137, Value2 = 137 },
                    { Name = "Salmon Pink", Value1 = 136, Value2 = 136 },
                    { Name = "Sunrise Orange", Value1 = 36, Value2 = 36 },
                    { Name = "Race Yellow", Value1 = 89, Value2 = 89 },
                    { Name = "Racing Green", Value1 = 50, Value2 = 50 },
                    { Name = "Lime Green", Value1 = 92, Value2 = 92 },
                    { Name = "Midnight Blue", Value1 = 141, Value2 = 141 },
                    { Name = "Galaxy Blue", Value1 = 61, Value2 = 61 },
                    { Name = "Dark Blue", Value1 = 62, Value2 = 62 },
                    { Name = "Diamond Blue", Value1 = 67, Value2 = 67 },
                    { Name = "Surf Blue", Value1 = 68, Value2 = 68 },
                    { Name = "Racing Blue", Value1 = 73, Value2 = 73 },
                    { Name = "Ultra Blue", Value1 = 70, Value2 = 70 },
                    { Name = "Light Blue", Value1 = 74, Value2 = 74 },
                    { Name = "Chocolate Brown", Value1 = 96, Value2 = 96 },
                    { Name = "Bison Brown", Value1 = 101, Value2 = 101 },
                    { Name = "Woodbeech Brown", Value1 = 102, Value2 = 102 },
                    { Name = "Bleached Brown", Value1 = 106, Value2 = 106 },
                    { Name = "Midnight Purple", Value1 = 142, Value2 = 142 },
                    { Name = "Bright Purple", Value1 = 145, Value2 = 145 },
                    { Name = "Cream", Value1 = 107, Value2 = 107 },
                    { Name = "Frost White", Value1 = 112, Value2 = 112 }
                }
                RageUI.List("Classiques", Listing.ColorMetalList, colorMetalList, nil, {}, true, {
                    onListChange = function(list, mls) 
                        colorMetalList = list end,
                    onSelected = function(list, mls)
                        local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                        SetVehicleColours(vehicle, mls.Value1, mls.Value2)
                end})  
                RageUI.Separator("~b~↓~s~ Mates ~b~↓")
                Listing.ColorList = {
                    { Name = "Black", Value1 = 12, Value2 = 12 },
                    { Name = "Gray", Value1 = 13, Value2 = 13 },
                    { Name = "Ice White", Value1 = 131, Value2 = 131 },
                    { Name = "Blue", Value1 = 83, Value2 = 83 },
                    { Name = "Schafter Purple", Value1 = 148, Value2 = 148 },
                    { Name = "Red", Value1 = 39, Value2 = 39 },
                    { Name = "Orange", Value1 = 41, Value2 = 41 },
                    { Name = "Yellow", Value1 = 42, Value2 = 42 },
                    { Name = "Green", Value1 = 128, Value2 = 128 }
                }
                RageUI.List("Mates", Listing.ColorList, colorList, nil, {}, true, {
                    onListChange = function(list, mls) 
                        colorList = list end,
                    onSelected = function(list, mls)
                        local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                        SetVehicleColours(vehicle, mls.Value1, mls.Value2)
                end})                              
        end)

        RageUI.IsVisible(customNeon, function()   
            Listing.ColorNeon = {
                { Name = "White", Value1 = 222, Value2 = 222, Value3 = 255 },	
                { Name = "Blue", Value1 = 2, Value2 = 21 , Value3 = 255 },
                { Name = "Electric Blue", Value1 = 3, Value2 = 83, Value3 = 255 },
                { Name = "Mint Green", Value1 = 0, Value2 = 255, Value3 = 140 },
                { Name = "Lime Green", Value1 = 94, Value2 = 255, Value3 = 1 },
                { Name = "Yellow", Value1 = 255, Value2 = 255, Value3 = 0 },
                { Name = "Orange", Value1 = 255, Value2 = 62, Value3 = 0 },
                { Name = "Red", Value1 = 255, Value2 = 1, Value3 = 1 },
                { Name = "Pony Pink", Value1 = 255, Value2 = 50, Value3 = 100 },
                { Name = "Hot Pink", Value1 = 255, Value2 = 5, Value3 = 190 },
                { Name = "Purple", Value1 = 35, Value2 = 1, Value3 = 255 },
                { Name = "Blacklight", Value1 = 15, Value2 = 3, Value3 = 255 }
            }                           
            RageUI.List("Neon", Listing.ColorNeon, colorNeon, nil, {}, true, {
                onListChange = function(list, cols) 
                    colorNeon = list end,
                onSelected = function(list, cols)
                    local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                    SetVehicleNeonLightEnabled(vehicle, 0, true)
                    SetVehicleNeonLightEnabled(vehicle, 1, true)
                    SetVehicleNeonLightEnabled(vehicle, 2, true)
                    SetVehicleNeonLightEnabled(vehicle, 3, true)
                    SetVehicleNeonLightsColour(vehicle, cols.Value1, cols.Value2, cols.Value3)
            end})  
        RageUI.Button("Supprimez les neons", nil, {}, true, {
            onSelected = function()
                local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                SetVehicleNeonLightEnabled(vehicle, 0, false)
                SetVehicleNeonLightEnabled(vehicle, 1, false)
                SetVehicleNeonLightEnabled(vehicle, 2, false)
                SetVehicleNeonLightEnabled(vehicle, 3, false)
        end})     
    end)

        if (OTEXO.SelfPlayer.isStaffEnabled) then
            RageUI.IsVisible(selectedMenu, function()
                table.sort(OTEXO.Players, function(a,b) return a.source < b.source end)
                if (selectedIndex == 1) then
                    if (#OTEXO.Players > 0) then

                        for i, v in pairs(OTEXO.Players) do
                            local gamertage = {
                                ["user"] = "Joueurs",
                                ["help"] = "Helpeur",
                                ["mod"] = "Modo",
                                ["admin"] = "Admin",
                                ["superadmin"] = "Gérant Staff",
                                ["owner"] = "Gérant Staff",
                                ["_dev"] = "Fondateur !!",
                            }                 
                            RageUI.Button(string.format('[%s] %s [%s]', v.source, v.name, gamertage[v.group]), 'Job : ~b~'..v.jobs..'~s~ | Gourp : ~b~'..v.group..'', {}, true, {
                                onSelected = function()
                                    playerActionMenu:SetSubtitle(string.format('[%s] %s', i, v.name))
                                    OTEXO.SelectedPlayer = v;
                                end
                            }, playerActionMenu)
                        end
                    else
                        RageUI.Separator("Aucun joueur en ligne.")
                    end
                end
                if (selectedIndex == 2) then
                    if (#OTEXO.PlayersStaff > 0) then
                        for i, v in pairs(OTEXO.PlayersStaff) do
                            local colors = {
                                ["_dev"] = '~r~',
                                ["superadmin"] = '~o~',
                                ["admin"] = '~b~',
                                ["modo"] = '~y~',
                            }
                            RageUI.Button(string.format('%s[%s] %s', colors[v.group], v.source, v.name), nil, {}, true, {
                                onSelected = function()
                                    playerActionMenu:SetSubtitle(string.format('[%s] %s', v.source, v.name))
                                    OTEXO.SelectedPlayer = v;
                                end
                            }, playerActionMenu)
                        end
                    else
                        RageUI.Separator("Aucun joueur en ligne.")
                    end
                end

                if (selectedIndex == 3) then
                    --idtosanctionbaby

                    for i, v in pairs(OTEXO.Players) do
                        if v.source == idtosanctionbaby then
                            RageUI.Separator("~b~↓~s~ INFORMATION ~b~↓")
                            RageUI.Button('ID : ' .. idtosanctionbaby, nil, {}, true, {
                                onSelected = function()
                                end
                            })
        
                            RageUI.Button('Nom : ' .. v.name, nil, {}, true, {
                                onSelected = function()
                                end
                            })
                            RageUI.Button('Jobs : ' .. v.jobs, nil, {}, true, {
                                onSelected = function()
                                end
                            })
                        end
                    end

                    RageUI.Separator("↓ ~s~SANCTION ~b~↓")
                    RageUI.List('Temps de ban', {
                        { Name = "1 Heure", Value = '0.2' },
                        { Name = "12 Heure", Value = '1' },
                        { Name = "1 Semaine", Value = '7' },
                        { Name = "1 Mois", Value = '30' },
                        { Name = "Permanent", Value = '0' },
                    }, GroupIndex, "Pour mettre le temps de ban ! ~g~(Entrée pour valider)\n", {}, true, {
                        onListChange = function(Index, Item)
                            GroupItem = Item;
                            GroupIndex = Index;
                        end,
                    })
                    RageUI.Button('Raison du ban', nil, { RightLabel = '~b~'..raisontosend }, true, {
                        onSelected = function()
                            local Raison = KeyboardInput('OTEXO_BOX_BAN_RAISON', "Raison du ban", '', 50)
                            raisontosend = Raison
                        end
                    })

                    RageUI.Button('Valider', nil, { RightLabel = "✅" }, true, {
                        onSelected = function()
                            TriggerServerEvent("OTEXO:Ban", idtosanctionbaby, GroupItem.Value, raisontosend)
                        end
                    })
                end

                if (selectedIndex == 4) then
                    for i, v in pairs(OTEXO.Players) do
                        if v.source == idtosanctionbaby then
                            RageUI.Separator("~b~↓~s~ INFORMATION ~b~↓")
                            RageUI.Button('ID : ' .. idtosanctionbaby, nil, {}, true, {
                                onSelected = function()
                                end
                            })
        
                            RageUI.Button('Nom : ' .. v.name, nil, {}, true, {
                                onSelected = function()
                                end
                            })
                            RageUI.Button('Jobs : ' .. v.jobs, nil, {}, true, {
                                onSelected = function()
                                end
                            })
                        end
                    end
                    RageUI.Separator("~b~↓~s~ SANCTION ~b~↓")
                    RageUI.Button('Raison du kick', nil, { RightLabel = '~b~'..raisontosend }, true, {
                        onSelected = function()
                            local Raison = KeyboardInput('OTEXO_BOX_BAN_RAISON', "Raison du ban", '', 50)
                            raisontosend = Raison
                        end
                    })

                    RageUI.Button('Valider', nil, { RightLabel = "✅" }, true, {
                        onSelected = function()
                            TriggerServerEvent("OTEXO:kick", idtosanctionbaby, raisontosend)
                        end
                    })
                end
                if (selectedIndex == 6) then
                    for i, v in pairs(OTEXO.Players) do
                        if v.source == idtoreport then
                            RageUI.Button('Nom : ~b~' .. v.name, nil, {}, true, {
                                onSelected = function()
                                end
                            })
                            RageUI.Button('ID : ~b~' .. idtoreport, nil, {}, true, {
                                onSelected = function()
                                end
                            })
                            RageUI.Button('Jobs : ~b~' .. v.jobs, nil, {}, true, {
                                onSelected = function()
                                end
                            })
                        end
                    end

                    RageUI.Line(52, 235, 235, 200)

                    RageUI.Button('Se Teleporter sur lui', nil, {}, true, {
                        onSelected = function()
                            TriggerServerEvent("OTEXO:teleport", idtoreport)
                        end
                    })
                    RageUI.Button('Le Teleporter sur moi', nil, {}, true, {
                        onSelected = function()
                            TriggerServerEvent("OTEXO:teleportTo", idtoreport)
                        end
                    })
                    RageUI.Button('Le Teleporter au Parking Central', nil, {}, true, {
                        onSelected = function()
                            TriggerServerEvent('OTEXO:teleportcoords', idtoreport, vector3(215.76, -810.12, 30.73))
                        end
                    })

                    RageUI.Button('Le Revive', nil, {}, true, {
                        onSelected = function()
                            TriggerServerEvent("OTEXO:Revive", idtoreport)
                        end
                    })

                    RageUI.Line(52, 235, 235, 200)

                    RageUI.Button('~g~Report Effectué', nil, { }, true, {
                        onSelected = function()
                            TriggerServerEvent("OTEXO:ReportRegle", kvdureport)
                            TriggerEvent("OTEXO:RefreshReport")
                        end
                    }, reportmenu)
                end
            end)

            RageUI.IsVisible(playerActionMenu, function()
                yo = ""
                if specateactive then
                    yo = "✔"
                end


                RageUI.Button("Spectate", nil, { RightLabel = yo }, true, { 
                    onSelected = function()
                        spectate(OTEXO.SelectedPlayer.source)
                    end 
                })

                RageUI.Button('Le Revive', nil, {}, true, {
                    onSelected = function()
                        TriggerServerEvent("OTEXO:Revive", OTEXO.SelectedPlayer.source)
                    end
                })

                RageUI.Button('Send Private Message', nil, {}, true, {
                    onSelected = function()
                        local msg = KeyboardInput('OTEXO_BOX_BAN_RAISON', "Message Privée", '', 50)
                        
                        if msg ~= nil then
                            msg = tostring(msg)
                    
                            if type(msg) == 'string' then
                                TriggerServerEvent("OTEXO:Message", OTEXO.SelectedPlayer.source, msg)
                            end
                        end
                        ESX.ShowNotification("Vous venez d'envoyer le message à ~r~" .. GetPlayerName(GetPlayerFromServerId(OTEXO.SelectedPlayer.source)))
                    end
                })

                RageUI.Line(52, 235, 235, 200)
                
                RageUI.Button('Vous téléporter sur lui', nil, {}, true, {
                    onSelected = function()
                        TriggerServerEvent('OTEXO:teleport', OTEXO.SelectedPlayer.source)
                    end
                })
                RageUI.Button('Téléporter vers vous', nil, {}, true, {
                    onSelected = function()
                        TriggerServerEvent('OTEXO:teleportTo', OTEXO.SelectedPlayer.source)
                    end
                })

                RageUI.Button('Le téléporter au Parking Central', nil, {}, true, {
                    onSelected = function()
                        TriggerServerEvent('OTEXO:teleportcoords', OTEXO.SelectedPlayer.source, vector3(215.76, -810.12, 30.73))
                    end
                })

                RageUI.Line(52, 235, 235, 200)

                RageUI.Button('Bannir le joueur', nil, {}, true, {
                    onSelected = function()
                        selectedMenu:SetSubtitle(string.format('Bannir le joueur'))
                        idtosanctionbaby = OTEXO.SelectedPlayer.source
                        selectedIndex = 3;
                    end
                }, selectedMenu)

                RageUI.Button('Kick le joueur', nil, {}, true, {
                    onSelected = function()
                        selectedMenu:SetSubtitle(string.format('Kick le joueur'))
                        idtosanctionbaby = OTEXO.SelectedPlayer.source
                        selectedIndex = 4;
                    end
                }, selectedMenu)

                RageUI.Line(52, 235, 235, 200)

                RageUI.Button("Wipe l'inventaire du Joueur", nil, {RightLabel = nil}, true, {
                    onSelected = function()
                        ExecuteCommand("clearinventory "..OTEXO.SelectedPlayer.source)
                    ESX.ShowAdvancedNotification("Administration", "~r~Informations", "Vous venez de WIPE les items de ~b~".. GetPlayerName(GetPlayerFromServerId(OTEXO.SelectedPlayer.source)) .."~s~ !", "CHAR_SUNLITE", 1) 																
                    end
                })

                RageUI.Button("Wipe les Armes du Joueur", nil, {RightLabel = nil}, true, {
                    onSelected = function()
                        ExecuteCommand("clearloadout "..OTEXO.SelectedPlayer.source)
                    ESX.ShowAdvancedNotification("Administration", "~r~Informations", "Vous venez de WIPE les armes de ~b~".. GetPlayerName(GetPlayerFromServerId(OTEXO.SelectedPlayer.source)) .."~s~ !", "CHAR_SUNLITE", 1) 								
                    end
                })

            end)

            RageUI.IsVisible(reportmenu, function()
                for i, v in pairs(OTEXO.GetReport) do
                    if i == 0 then
                        return
                    end
                    RageUI.Button("[" .. v.id .. "] " .. v.name , "ID : " .. v.id .. "\n" .. "Name : " .. v.name .. "\nRaison : " .. v.reason, {}, true, {
                        onSelected = function()
                            selectedMenu:SetSubtitle(string.format('Report'))
                            kvdureport = i
                            idtoreport = v.id
                            selectedIndex = 6;
                        end
                    }, selectedMenu)
                end
            end)
        end
        for i, onTick in pairs(OTEXO.Menus) do
            onTick();
        end
    end
    Citizen.Wait(500)
end)

local function getEntity(player)
    -- function To Get Entity Player Is Aiming At
    local _, entity = GetEntityPlayerIsFreeAimingAt(player)
    return entity
end

local function aimCheck(player)
    -- function to check config value onAim. If it's off, then
    return IsPedShooting(player)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)

        if (OTEXO.SelfPlayer.isStaffEnabled) then
            if (OTEXO.SelfPlayer.isDelgunEnabled) then
                if IsPlayerFreeAiming(PlayerId()) then
                    local entity = getEntity(PlayerId())
                    if GetEntityType(entity) == 2 or 3 then
                        if aimCheck(GetPlayerPed(-1)) then
                            SetEntityAsMissionEntity(entity, true, true)
                            DeleteEntity(entity)
                        end
                    end
                end
            end

            --if (OTEXO.SelfPlayer.isStaffEnabled) then
                if (OTEXO.SelfPlayer.ShowCoords) then
                    plyPed = PlayerPedId()
                    local plyCoords = GetEntityCoords(plyPed, false)
                    Text('~b~X~s~: ' .. ESX.Math.Round(plyCoords.x, 2) .. '\n~o~Y~s~: ' .. ESX.Math.Round(plyCoords.y, 2) .. '\n~g~Z~s~: ' .. ESX.Math.Round(plyCoords.z, 2) .. '\n~r~H~s~: ' .. ESX.Math.Round(GetEntityPhysicsHeading(plyPed), 2))
                end
            --end

            function Text(text)
                SetTextColour(186, 186, 186, 255)
                SetTextFont(0)
                SetTextScale(0.500, 0.500)
                SetTextWrap(0.0, 1.0)
                SetTextCentre(false)
                SetTextDropshadow(0, 0, 0, 0, 255)
                SetTextEdge(1, 0, 0, 0, 205)
                BeginTextCommandDisplayText('STRING')
                AddTextComponentSubstringPlayerName(text)
                EndTextCommandDisplayText(0.175, 0.81)
            end

            if (OTEXO.SelfPlayer.isClipping) then
                --HideHudAndRadarThisFrame()

                local camCoords = GetCamCoord(NoClip.Camera)
                local right, forward, _, _ = GetCamMatrix(NoClip.Camera)
                if IsControlPressed(0, 32) then
                    local newCamPos = camCoords + forward * NoClip.Speed
                    SetCamCoord(NoClip.Camera, newCamPos.x, newCamPos.y, newCamPos.z)
                end
                if IsControlPressed(0, 8) then
                    local newCamPos = camCoords + forward * -NoClip.Speed
                    SetCamCoord(NoClip.Camera, newCamPos.x, newCamPos.y, newCamPos.z)
                end
                if IsControlPressed(0, 34) then
                    local newCamPos = camCoords + right * -NoClip.Speed
                    SetCamCoord(NoClip.Camera, newCamPos.x, newCamPos.y, newCamPos.z)
                end
                if IsControlPressed(0, 9) then
                    local newCamPos = camCoords + right * NoClip.Speed
                    SetCamCoord(NoClip.Camera, newCamPos.x, newCamPos.y, newCamPos.z)
                end
                if IsControlPressed(0, 334) then
                    if (NoClip.Speed - 0.1 >= 0.1) then
                        NoClip.Speed = NoClip.Speed - 0.1
                    end
                end
                if IsControlPressed(0, 335) then
                    if (NoClip.Speed + 0.1 >= 0.1) then
                        NoClip.Speed = NoClip.Speed + 0.1
                    end
                end

                SetEntityCoords(OTEXO.SelfPlayer.ped, camCoords.x, camCoords.y, camCoords.z)

                local xMagnitude = GetDisabledControlNormal(0, 1)
                local yMagnitude = GetDisabledControlNormal(0, 2)
                local camRot = GetCamRot(NoClip.Camera)
                local x = camRot.x - yMagnitude * 10
                local y = camRot.y
                local z = camRot.z - xMagnitude * 10
                if x < -75.0 then
                    x = -75.0
                end
                if x > 100.0 then
                    x = 100.0
                end
                SetCamRot(NoClip.Camera, x, y, z)
            end

            if (OTEXO.SelfPlayer.isGamerTagEnabled) then
                for i, v in pairs(OTEXO.GamerTags) do
                    local target = GetEntityCoords(v.ped, false);

                    if #(target - GetEntityCoords(PlayerPedId())) < 120 then
                        SetMpGamerTagVisibility(v.tags, 0, true)
                        SetMpGamerTagVisibility(v.tags, 2, true)

                        SetMpGamerTagVisibility(v.tags, 4, NetworkIsPlayerTalking(v.player))
                        SetMpGamerTagAlpha(v.tags, 2, 255)
                        SetMpGamerTagAlpha(v.tags, 4, 255)

                        local colors = {
                            ["_dev"] = 50,
                            ["superadmin"] = 25,
                            ["owner"] = 25,
                            ["admin"] = 8,
                            ["mod"] = 40,
                            ["help"] = 21,
                        }
                        SetMpGamerTagColour(v.tags, 0, colors[v.group] or 0)
                    else
                        RemoveMpGamerTag(v.tags)
                        OTEXO.GamerTags[i] = nil;
                    end
                end


            end

        end
    end
end)

Citizen.CreateThread(function()
    while true do
        OTEXO.SelfPlayer.ped = GetPlayerPed(-1);
        if (OTEXO.SelfPlayer.isStaffEnabled) then
            if (OTEXO.SelfPlayer.isGamerTagEnabled) then
                OTEXO.Helper:OnRequestGamerTags();
            end
        end
        Citizen.Wait(1000)
    end
end)


RegisterNetEvent('OTEXO:teleport')
AddEventHandler('OTEXO:teleport', function(coords)
    if (OTEXO.SelfPlayer.isClipping) then
        SetCamCoord(NoClip.Camera, coords.x, coords.y, coords.z)
        SetEntityCoords(OTEXO.SelfPlayer.ped, coords.x, coords.y, coords.z)
    else
        ESX.Game.Teleport(PlayerPedId(), coords)
    end
end)

RegisterNetEvent('OTEXO:spawnVehicle')
AddEventHandler('OTEXO:spawnVehicle', function(model)
    if (OTEXO.SelfPlayer.isStaffEnabled) then
        model = (type(model) == 'number' and model or GetHashKey(model))

        if IsModelInCdimage(model) then
            local playerPed = PlayerPedId()
            local plyCoords = GetEntityCoords(playerPed)

            ESX.Game.SpawnVehicle(model, plyCoords, 90.0, function(vehicle)
                TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
            end)
        else
            ESX.ShowNotification('Modèle de véhicule invalide.', 5000)
        end
    end
end)

local disPlayerNames = 5
local playerDistances = {}

local function DrawText3D(x, y, z, text, r, g, b)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local dist = #(vector3(px, py, pz) - vector3(x, y, z))

    local scale = (1 / dist) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov

    if onScreen then
        if not useCustomScale then
            SetTextScale(0.0 * scale, 0.55 * scale)
        else
            SetTextScale(0.0 * scale, customScale)
        end
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(r, g, b, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

Citizen.CreateThread(function()
    Wait(500)
    while true do
        if (OTEXO.SelfPlayer.isGamerTagEnabled) then
            for _, id in ipairs(GetActivePlayers()) do
                local serverId = GetPlayerServerId(id)
                local CCS = {
                    ["_dev"] = "~u~",
                    ["owner"] = "~r~",
                    ["superadmin"] = "~r~",
                    ["admin"] = "~q~",
                    ["modo"] = "~b~",
                    ["help"] = "~g~",
                    ["user"] = "",
                }

                local formatted = nil;
                if group == '_dev' then
                    formatted = string.format('~h~~u~[Fondateur] ~w~%s~w~', GetPlayerName(id))
                end
                if playerDistances[id] then
                    if (playerDistances[id] < disPlayerNames) then
                        x2, y2, z2 = table.unpack(GetEntityCoords(GetPlayerPed(id), true))
                        if NetworkIsPlayerTalking(id) then
                            DrawText3D(x2, y2, z2 + 1, GetPlayerServerId(id), 52, 235, 235)
                            DrawMarker(1, x2, y2, z2 - 1.2, 0, 0, 0, 0, 0, 0, 1.001, 1.0001, 0.8001, 52, 235, 235, 200, 1, 0, 0, 0)
                        else
                            DrawText3D(x2, y2, z2 + 1, GetPlayerServerId(id), 255, 255, 255)
                        end
                    elseif (playerDistances[id] < 25) then
                        x2, y2, z2 = table.unpack(GetEntityCoords(GetPlayerPed(id), true))
                        if NetworkIsPlayerTalking(id) then
                            DrawMarker(1, x2, y2, z2 - 0.97, 0, 0, 0, 0, 0, 0, 1.001, 1.0001, 0.5001, 52, 235, 235, 150, 1, 0, 0, 0)
                        end
                    end
                end
            end
        end
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        if (OTEXO.SelfPlayer.isGamerTagEnabled) then
            for _, id in ipairs(GetActivePlayers()) do

                x1, y1, z1 = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
                x2, y2, z2 = table.unpack(GetEntityCoords(GetPlayerPed(id), true))
                distance = math.floor(#(vector3(x1, y1, z1) - vector3(x2, y2, z2)))
                playerDistances[id] = distance
            end
        end
        Citizen.Wait(1000)
    end
end)

function refreshFouilleStaff(thePlayer)
	ESX.TriggerServerCallback('staff:getOtherPlayerData', function(data)
		fouilleElements = {}

		for i = 1, #data.accounts, 1 do
			if data.accounts[i].name == 'dirtycash' and data.accounts[i].money > 0 then
				table.insert(fouilleElements, {
					label = _U('confiscate_dirty', ESX.Math.Round(data.accounts[i].money)),
					value = 'dirtycash',
					itemType = 'item_account',
					amount = data.accounts[i].money
				})

				break
			end
		end

		table.insert(fouilleElements, {
			label = _U('inventory_label'),
			value = nil
		})

		for i = 1, #data.inventory, 1 do
			if data.inventory[i].count > 0 then
				table.insert(fouilleElements, {
					label = _U('confiscate_inv', data.inventory[i].count, data.inventory[i].label),
					value = data.inventory[i].name,
					itemType = 'item_standard',
					amount = data.inventory[i].count
				})
			end
		end

		table.insert(fouilleElements, {
			label = _U('guns_label'),
			value = nil
		})

		for i = 1, #data.weapons, 1 do
			table.insert(fouilleElements, {
				label = _U('confiscate_weapon', ESX.GetWeaponLabel(data.weapons[i].name), data.weapons[i].ammo),
				value = data.weapons[i].name,
				itemType = 'item_weapon',
				amount = data.weapons[i].ammo
			})
		end
	end, GetPlayerServerId(thePlayer))
end
