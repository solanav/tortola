defmodule Tortola do
    use Application
    import Crontab.CronExpression

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

        # Update cron from db every 5 minutes
        Tortola.Scheduler.add_job({~e[*/5 * * * *], &Tortola.CronWatchdog.update/0})

        # Start supervisor tree
        opts = [strategy: :one_for_one, name: Tortola.Supervisor]
        Supervisor.start_link(children, opts)
    end
end
