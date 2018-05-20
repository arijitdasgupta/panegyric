defmodule RedisRepo do
    require Logger

    def start(redisHost, redisPort) do
        {:ok, redisAgent} = Agent.start_link(fn -> %{redisConn: nil} end, name: __MODULE__)
        redisConn = case Redix.start_link(host: redisHost, port: redisPort) do
            {:ok, conn} -> conn
            {:error, _} -> raise("Error while connecting to Redis")
        end

        Logger.info("Connected to Redis")

        Agent.update(redisAgent, fn _ -> 
            %{redisConn: redisConn} 
        end)

        {:ok, redisAgent}
    end

    def getRedisConn do
        Agent.get(__MODULE__, fn item -> 
            case item.redisConn do
                nil -> nil
                conn -> conn
            end
        end)
    end
end