defmodule App do
    use Application
    require Logger

    defp start(_type, _args, port) do
        Logger.info("Starting application")
        redisHost = Application.get_env(:panegyric, :redisHost)
        redisPort = Application.get_env(:panegyric, :redisPort)
        {:ok, redisAgent} = RedisRepo.start(redisHost, redisPort)
        children = [Plug.Adapters.Cowboy.child_spec(:http, Panegyric, [], port: port)]
        Supervisor.start_link(children, strategy: :one_for_one)
    end

    def start(type, args) do
        start(type, args, 8080)
    end

    def start(port) do
        start([], [], port)
    end

    def start() do
        start([], [], 8080)
    end
end