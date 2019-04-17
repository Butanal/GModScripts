local idle = {
    t = 0,
    last_message = 0,
    stopped = false,
    mx = 0,
    my = 0,
    afk = false
}

local function checkIdle(client, cmd)
    if not IsValid(client) then return end

    local curtime = os.time()

    if idle.t == 0 then
        -- init things
        idle.t = curtime
        idle.mx = gui.MouseX()
        idle.my = gui.MouseY()

        return
    end

    if GetRoundState() == ROUND_ACTIVE and client:IsTerror() and client:Alive() then
        if idle.stopped then -- prevent messing up after new round
            idle.t = curtime
            idle.stopped = false
        end

        local idle_limit = 120

        -- networking sucks sometimes
        if idle_limit <= 0 then
            idle_limit = 300
        end

        if cmd:GetButtons() ~= 0 or math.abs(cmd:GetMouseX()) > 2 or math.abs(cmd:GetMouseY()) > 2 then
            idle.t = curtime
            idle.afk = false
        elseif system.HasFocus() and (gui.MouseX() ~= idle.mx or gui.MouseY() ~= idle.my) then
            -- why the fuck is mousepos given without focus lol?
            idle.t = curtime
            idle.afk = false
            idle.mx = gui.MouseX()
            idle.my = gui.MouseY()
        elseif not idle.afk and curtime > (idle.t + idle_limit) then
            idle.afk = true
            RunConsoleCommand("say", "(AUTOMATED MESSAGE) I have been moved to the Spectator team because I was idle/AFK.")

            timer.Simple(0.3, function()
                RunConsoleCommand("ttt_spectator_mode", 1)
                net.Start("TTT_Spectate")
                net.WriteBool(true)
                net.SendToServer()
                RunConsoleCommand("ttt_cl_idlepopup")
            end)
        elseif curtime - idle.last_message >= 5 and curtime > (idle.t + (idle_limit / 2)) then
            -- will repeat
            idle.last_message = curtime
            LANG.Msg("idle_warning")
        end
    else
        idle.stopped = true
    end
end

hook.Add("Initialize", "BetterAntiAFK", function()
    if not system.IsOSX() then -- keep legacy check for OSX (see https://wiki.garrysmod.com/page/system/HasFocus)
        timer.Remove("idlecheck")
        hook.Add("StartCommand", "BetterAntiAFK", checkIdle)
    end
end )
