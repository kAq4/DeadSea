getgenv().MJ = getgenv().MJ or {}

MJ.PingSpoof = false
MJ.Ping = 0

return {
    Name = "Ping Spoofer",
    Category = "Network",
    Enabled = false,

    Toggle = function(state)

        MJ.PingSpoof = state

        if not state then
            settings().Network.IncomingReplicationLag = 0
        end

    end,

    Slider = {
        Name = "Fake Ping",
        Min = 0,
        Max = 1000,
        Increment = 10,
        Default = 0,

        Callback = function(v)

            MJ.Ping = v

            if MJ.PingSpoof then
                settings().Network.IncomingReplicationLag = v / 1000
            end

        end
    }
}