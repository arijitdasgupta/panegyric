defmodule Panegyric do
    @moduledoc """
    Documentation for Panegyric.
    """
    use Plug.Router
    require Redix

    plug :match
    plug :dispatch

    def init(options) do
      options
    end

    match "/keys/*_", to: KeysApp, init_opts: []

    match(_, do: send_resp(conn, 404, "Oops!"))
end
