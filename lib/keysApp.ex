defmodule HTTPResp do
    defstruct status: nil,  body: ""
end

defmodule KeysApp do
    use Plug.Router
    require Redix

    plug Plug.Logger
    plug :match
    plug :dispatch

    def init(options) do
        options
    end

    get "/keys/:key" do
        redisConn = RedisRepo.getRedisConn

        resp = case Redix.command(redisConn, ["GET", key]) do
            {:ok, value} when value != nil -> %HTTPResp{status: 200, body: value}
            {:ok, nil} -> %HTTPResp{status: 404, body: ""}
            {:error, _} -> %HTTPResp{status: 500, body: "ERROR"}
        end

        send_resp(conn, resp.status, resp.body)
      end
  
    post "/keys/:key" do
        redisConn = RedisRepo.getRedisConn

        body = case read_body(conn) do
            {:ok, body, _} -> body
            {:more, body, _} -> body
            {:error, _, _} -> raise("Something went wrong")    
        end
        
        resp = case Redix.command(redisConn, ["SET", key, body]) do
            {:ok, _} -> %HTTPResp{status: 200, body: "OK"}
            {:error, _} -> %HTTPResp{status: 500, body: "ERROR"}
        end

        send_resp(conn, resp.status, resp.body)
    end

    delete "/keys/:key" do
        redisConn = RedisRepo.getRedisConn
        
        resp = case Redix.command(redisConn, ["DEL", key]) do
            {:ok, 1} -> %HTTPResp{status: 200, body: "OK"}
            {:ok, 0} -> %HTTPResp{status: 404}
            {:error, _} -> %HTTPResp{status: 500, body: "ERROR"}    
        end 
        
        send_resp(conn, resp.status, resp.body)
    end
end