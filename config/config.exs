import Config

config :tortola, Tortola,
    dbusername: "admin",
    dbpassword: ")H-N@2)ekDi52>;X",
    dbhostname: "192.168.202.10",
    dbport: 3333    

config :tortola, Tortola.Scheduler,
    overlap: false,
    jobs: [
        {{:extended, "*/30 * * * *"}, &Tortola.CronWatchdog.update/0}
    ]

config :elixir, :time_zone_database, Tz.TimeZoneDatabase