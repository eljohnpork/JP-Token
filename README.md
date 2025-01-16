# JP-token Anti-Cheat Script

Het **JP-token Anti-Cheat Script** is een geavanceerd beveiligingssysteem voor FiveM-servers. Het gebruikt dynamische tokens om gevoelige acties en serverevents te beveiligen tegen cheaters. Elke token is uniek, kan slechts één keer worden gebruikt, en is gebonden aan een specifieke speler.

## 🚀 Features
- **Dynamische tokens**: Willekeurig gegenereerde tokens voor maximale beveiliging.
- **Eénmalig gebruik**: Tokens kunnen slechts één keer worden gevalideerd.
- **Spelerbinding**: Tokens zijn specifiek gekoppeld aan de speler die ze heeft aangevraagd.
- **Automatische opschoning**: Verlopen tokens worden regelmatig verwijderd.
- **Anti-Cheat Kick**: Cheaters die ongeldige of verlopen tokens gebruiken, worden automatisch gekickt.
- **Exports**: Integreer eenvoudig in andere scripts.

---

## 📦 Installatie

1. **Download en plaats bestanden:**
   - Voeg `jp_token_anticheat.lua` toe aan de resource-map van je server.
   - Voeg ook het `fxmanifest.lua` bestand toe.

2. **Voeg toe aan `server.cfg`:**
   ```plaintext
   ensure jp-token-anticheat
   ```

3. **Herstart de server.**

---

## 🛠️ Gebruik

### **Exports**
Gebruik de volgende exports in je scripts om tokens te genereren en te valideren:

1. **Genereer een nieuwe token:**
   ```lua
   local token = exports["jp-token"]:getToken(source)
   print("Gegenereerde token: " .. token)
   ```

2. **Valideer een token:**
   ```lua
   local isValid = exports["jp-token"]:validateToken(token, source)
   if isValid then
       print("Token is geldig!")
   else
       print("Token is ongeldig!")
   end
   ```

---

## 📖 Voorbeeld

**Server-side script:**
```lua
RegisterServerEvent("secureEvent")
AddEventHandler("secureEvent", function(token)
    local source = source
    local isValid = exports["jp-token"]:validateToken(token, source)
    if isValid then
        print("[SecureEvent] Token is geldig voor: " .. GetPlayerName(source))
        -- Voer beveiligde actie uit
    else
        print("[SecureEvent] Ongeldige token voor speler: " .. GetPlayerName(source))
        -- Speler wordt automatisch gekickt
    end
end)
```

**Client-side script:**
```lua
RegisterCommand("triggerSecureEvent", function()
    local token = exports["jp-token"]:getToken()
    if token then
        TriggerServerEvent("secureEvent", token)
    else
        print("Fout: Geen token kunnen ophalen.")
    end
end, false)
```

---

## 🔐 Beveiligingstips
- Gebruik tokens voor gevoelige acties zoals het starten van heists, verkrijgen van zeldzame items, of toegang tot belangrijke events.
- Houd tokens kort geldig (`tokenExpiry` in het script) om het risico op hergebruik te minimaliseren.
- Monitor logs voor verdachte activiteiten.

---

## 🧩 Configuratie

De configuratie-opties bevinden zich in `jp_token_anticheat.lua`:

1. **Tokenlengte:**
   ```lua
   local tokenLength = 16
   ```
   Lengte van de gegenereerde tokens.

2. **Token vervaltijd:**
   ```lua
   local tokenExpiry = 300
   ```
   Tijd in seconden voordat een token verloopt.

---

## 🛡️ Credits
Gemaakt door **John Pork**. Voor vragen en ondersteuning, neem contact op via discord eljohnpork. . 😊
