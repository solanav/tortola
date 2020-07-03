defmodule Tortola do
    use Application

    @moduledoc false
    def start(_type, _args) do
        env = Application.get_env(:tortola, Tortola)
        
        children = [
            {
                MyXQL,
                username: env[:dbusername],
                password: env[:dbpassword],
                hostname: env[:dbhostname],
                port: env[:dbport],
                name: :ddbb
            },
            Tortola.CronWatchdog,
            Tortola.Scheduler
        ]

        # Start supervisor tree
        opts = [strategy: :one_for_one, name: Tortola.Supervisor]
        Supervisor.start_link(children, opts)
    end
end
