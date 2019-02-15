defmodule AnagramWeb.Router do
  use AnagramWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AnagramWeb do
    pipe_through :api

    get "/compare", AnagramController, :compare
    get "/find", AnagramController, :find
    get "/longest", AnagramController, :longest
    get "/index", AnagramController, :index
    post "/create", AnagramController, :create
    delete "/delete", AnagramController, :delete
  end
end
