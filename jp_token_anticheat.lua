ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local activeTokens = {}
local tokenLength = 16 -- Lengte van de gegenereerde token
local tokenExpiry = 300 -- Token vervaltijd in seconden

-- Functie om een willekeurige token te genereren
local function generateToken()
    local characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local token = ""
    for i = 1, tokenLength do
        local randomIndex = math.random(1, #characters)
        token = token .. characters:sub(randomIndex, randomIndex)
    end
    return token
end

-- Functie om een nieuwe token te verversen
local function refreshTokenForPlayer(source)
    local newToken = generateToken()
    activeTokens[newToken] = {expiry = os.time() + tokenExpiry, source = source}
    return newToken
end

-- Export functie om een geldige token op te halen
exports("getToken", function(source)
    return refreshTokenForPlayer(source)
end)

-- Export functie om een token te valideren
exports("validateToken", function(token, source)
    local currentTime = os.time()
    if activeTokens[token] and activeTokens[token].expiry > currentTime and activeTokens[token].source == source then
        -- Token is geldig, verwijder deze
        activeTokens[token] = nil
        return true
    else
        -- Token is ongeldig of al verlopen
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            xPlayer.kick("[Anti-Cheat] Ongeldig of verlopen token gebruikt. Je bent gekickt van de server.")
        end
        print("[Anti-Cheat]: Speler " .. GetPlayerName(source) .. " probeerde een ongeldig of verlopen token te gebruiken.")
        return false
    end
end)

-- Periodiek opschonen van verlopen tokens
Citizen.CreateThread(function()
    while true do
        Wait(60000) -- Elke minuut verlopen tokens opschonen
        local currentTime = os.time()
        for token, data in pairs(activeTokens) do
            if data.expiry <= currentTime then
                activeTokens[token] = nil
            end
        end
    end
end)

-- Optioneel: Event voor loggen van token gebruik
RegisterNetEvent("jp-token:logUsage")
AddEventHandler("jp-token:logUsage", function(source, token)
    local isValid = exports["jp-token"]:validateToken(token, source)
    if isValid then
        print("[Anti-Cheat]: Token gebruikt door speler " .. GetPlayerName(source) .. ".")
    end
end)

