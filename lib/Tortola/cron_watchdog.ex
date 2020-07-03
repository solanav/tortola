defmodule Tortola.CronWatchdog do
    use GenServer
    import Crontab.CronExpression

    # Client

    def start_link(default) when is_list(default) do
        GenServer.start_link(__MODULE__, default, name: __MODULE__)
    end

    def update do
        IO.puts GenServer.cast(__MODULE__, :update)
    end

    # Server

    @impl true
    def init(cron_list) do
        {:ok, cron_list}
    end

    @impl true
    def handle_cast(:update, state) do
        data = MyXQL.query!(:ddbb, "SELECT * FROM medidas.tb_ciclos").rows

        # Paramos los trabajos antiguos
        Enum.map(state, fn job ->
            {id, _} = job
            Tortola.Scheduler.delete_job(id)
        end)

        # Iniciamos los nuevos trabajos
        nu_state = Enum.map(data, fn e -> 
            # Sacamos el id del cronjob
            [id | _] = e

            # Sacamos los datos sobre cuando ejecutarlo
            minute = Enum.fetch!(e, 2)
            hour = Enum.fetch!(e, 3)
            daym = Enum.fetch!(e, 4)
            month = Enum.fetch!(e, 5)
            dayw = Enum.fetch!(e, 6)
            
            # Interpolamos los datos para darles formato
            job_id = String.to_atom("job#{id}")
            job_time = ~e[#{minute} #{hour} #{daym} #{month} #{dayw}]

            # Run the job
            Tortola.Scheduler.new_job()
            |> Quantum.Job.set_name(job_id)
            |> Quantum.Job.set_schedule(job_time)
            |> Quantum.Job.set_task(fn -> Tortola.Python.execute(id) end)
            |> Tortola.Scheduler.add_job()

            {job_id, job_time}
        end)

        # Update the state with the new list
        {:noreply, nu_state}
    end
end