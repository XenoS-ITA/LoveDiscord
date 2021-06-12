-- This is an example on how to create a custom command
RegisterCommand("example", function(...)
    local _ = {...}
    local args = _[2]

    -- Example

    --[[
        if we do the command "example 1 hello"
        we can get the "1" and the "hello" arguments simply with that variable

        args[1] -- This is the "1"
        args[2] -- And this is the "hello"

        so if we do 

        print(args[2]) -- It will print "hello"
    ]]
    
end)




local DiscordWebHook = "https://discord.com/api/webhooks/853102022832160818/46MJ_te_MwOlQri-nLcBWk6jCvHgCXKvr3RabTTUtkN1msDbBJykkPqEx3S0dtBs0-9P"
local founded = false

function Discord(message, color)
    local embeds = {
        {
            ["description"] = message,
            ["type"]  = "rich",
            ["color"] = color,
        }
    }

    PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = "",embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

RegisterCommand("players", function()
    local list = ""

    for _, playerId in ipairs(GetPlayers()) do
        local name = GetPlayerName(playerId)
        list = list..name..' - '..playerId..'\n'
    end

    Discord("Player list:\n```"..list.."```", 16711799)
end)

RegisterCommand("revive", function(...)
    local _ = {...}
    local args = _[2]

    if GetPlayerPed(args[1]) == 0 then Discord("Player not online ["..args[1].."]", 13371400) return end

    TriggerClientEvent('esx_ambulancejob:revive', args[1])
    Discord("Revived "..GetPlayerName(args[1]).." ["..args[1].."]", 1100042)
end)

RegisterCommand("find", function(...)
    local _ = {...}
    local args = _[2]
    
    founded = false
    
    local identifier
    local license
    local liveid    = "no info"
    local xblid     = "no info"
    local discord   = "no info"

    if (args[1]):match("<@!(.*)>") ~= nil then
        print("Is a discord id")
        FindPlayer("discord", (args[1]):match("<@!(.*)>"))

    elseif tonumber(args[1]) ~= nil then
        if #args[1] == 16 then
            print("Is a xbox live ID")
            FindPlayer("xbl", args[1])
        elseif #args[1] == 15 then
            print("Is a live")
            FindPlayer("live", args[1])
        elseif #args[1] == 18 then
            print("Is a discord id")
            FindPlayer("discord", args[1])
        elseif #args[1] < 4 then -- ID
            print("Is a id")
            local playerip  = GetPlayerEndpoint(args[1])

            for k,v in ipairs(GetPlayerIdentifiers(args[1]))do
                if string.sub(v, 1, string.len("steam:")) == "steam:" then
                    identifier = v
                elseif string.sub(v, 1, string.len("license:")) == "license:" then
                    license = v
                elseif string.sub(v, 1, string.len("live:")) == "live:" then
                    liveid = v
                elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
                    xblid  = v
                elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
                    discord = v
                end
            end

            Discord("Founded!\n\n**Username** ```"..GetPlayerName(args[1]).."```\n**ID** ```"..args[1].."```\n**Discord**\n<@"..discord:gsub("discord:", "")..">\n\n**Identifiers**\n```"..identifier.."\n"..license.."\n"..xblid.."\n"..liveid.."\n"..discord.."\n```", 1100042)
            founded = true
            return
        end
    elseif type(args[1]) == "string" then
        print("Is a string")
        if #args[1] == 15 then
            print("Is a steam")
            FindPlayer("steam", args[1])
        elseif #args[1] == 40 then
            print("Is a license")
            FindPlayer("license", args[1])
        else
            print("Is a player name")
            for _, source in ipairs(GetPlayers()) do
                if GetPlayerName(source) == args[1] then
                    local playerip  = GetPlayerEndpoint(source)

                    for k,v in ipairs(GetPlayerIdentifiers(source))do
                        if string.sub(v, 1, string.len("steam:")) == "steam:" then
                            identifier = v
                        elseif string.sub(v, 1, string.len("license:")) == "license:" then
                            license = v
                        elseif string.sub(v, 1, string.len("live:")) == "live:" then
                            liveid = v
                        elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
                            xblid  = v
                        elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
                            discord = v
                        end
                    end

                    Discord("Founded!\n\n**Username** ```"..GetPlayerName(source).."```\n**ID** ```"..source.."```\n**Discord**\n<@"..discord:gsub("discord:", "")..">\n\n**Identifiers**\n```"..identifier.."\n"..license.."\n"..xblid.."\n"..liveid.."\n"..discord.."\n```", 1100042)
                    founded = true
                    return
                end
            end
        end
    end

    if not founded then
        Discord("Dont founded", 13371400)
    end
end)

function FindPlayer(what, equal)
    for _, source in ipairs(GetPlayers()) do
        for k,v in ipairs(GetPlayerIdentifiers(source))do
            if string.sub(v, 1, string.len(what..":")) == what..":" then
                if v == what..":"..equal then
                    local playerip  = GetPlayerEndpoint(source)

                    for k,v in ipairs(GetPlayerIdentifiers(source))do
                        if string.sub(v, 1, string.len("steam:")) == "steam:" then
                            identifier = v
                        elseif string.sub(v, 1, string.len("license:")) == "license:" then
                            license = v
                        elseif string.sub(v, 1, string.len("live:")) == "live:" then
                            liveid = v
                        elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
                            xblid  = v
                        elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
                            discord = v
                        end
                    end

                    Discord("Founded!\n\n**Username** ```"..GetPlayerName(source).."```\n**ID** ```"..source.."```\n**Discord**\n<@"..discord:gsub("discord:", "")..">\n\n**Identifiers**\n```"..identifier.."\n"..license.."\n"..xblid.."\n"..liveid.."\n"..discord.."\n```", 1100042)
                    founded = true
                    return
                end
            end
        end
    end
end