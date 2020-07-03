defmodule Tortola.Python do
    @pythonpathdef "C:\\Users\\anton\\PycharmProjects\\untitled\\venv\\Scripts\\python.exe"
    @modulepathdef "C:\\Users\\anton\\PycharmProjects\\untitled\\main.py"

    def execute(ciclo) do
        # Datos para crear las fechas
        {:ok, now} = DateTime.now("Europe/Madrid")
        fechaini = DateTime.add(now, -7 * 3600 * 24, :second)
        fechafin = now

        # Creamos la fecha inicial
        fechaini = [fechaini.year, fechaini.month, fechaini.day, fechaini.hour, fechaini.minute, fechaini.second]
        |> Enum.map(&to_string/1)
        |> Enum.map(&String.pad_leading(&1, 2, "0"))
        |> Enum.join("-")

        # Creamos la fecha final
        fechafin = [fechafin.year, fechafin.month, fechafin.day, fechafin.hour, fechafin.minute, fechafin.second]
        |> Enum.map(&to_string/1)
        |> Enum.map(&String.pad_leading(&1, 2, "0"))
        |> Enum.join("-")

        # LLamamos al script
        System.cmd(@pythonpathdef, [
            @modulepathdef,
            "--fechaini", fechaini, # Pasamos la fecha inicial
            "--fechafin", fechafin, # Pasamos la fecha final
            Integer.to_string(ciclo), # Pasamos el ciclo
        ])
    end
end