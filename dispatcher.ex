defmodule Dispatcher do
  use Plug.Router

  def replicating_proxy, do: "http://172.31.101.135:3005/print/"
  def log_proxy, do: "http://172.31.101.135:3005/print/"

  def multi_proxy(conn, path, server) do
    IO.puts "in proxy function, proxying to " <> server
    Proxy.forward conn, path, server
    Proxy.forward conn, path, replicating_proxy
    Proxy.forward conn, path, log_proxy
  end

  def start(_argv) do
    port = 80
    IO.puts "Starting Plug with Cowboy on port #{port}"
    Plug.Adapters.Cowboy.http __MODULE__, [], port: port
    :timer.sleep(:infinity)
  end

  plug Plug.Logger
  plug :match
  plug :dispatch

  match "/sessions/*path" do
    multi_proxy conn, path, "http://login/sessions/"
  end

  match "/concepts/*path" do
    multi_proxy conn, path, "http://resource/concepts/"
  end

  match "/export/*path" do
    multi_proxy conn, path, "http://export/export"
  end

  match "/tasks/*path" do
    multi_proxy conn, path, "http://resource/tasks/"
  end

  match "/label-roles/*path" do
    multi_proxy conn, path, "http://resource/label-roles/"
  end

  match "/concept-labels/*path" do
    multi_proxy conn, path, "http://resource/concept-labels/"
  end

  match "/taxonomies/*path" do
    multi_proxy conn, path, "http://resource/taxonomies/"
  end

  match "/hierarchies/*path" do
    multi_proxy conn, path, "http://resource/hierarchies/"
  end

  match "/notifications/*path" do
    multi_proxy conn, path, "http://resource/notifications/"
  end

  match "/validation-result-collections/*path" do
    multi_proxy conn, path, "http://resource/validation-result-collections/"
  end

  match "/validation-results/*path" do
    multi_proxy conn, path, "http://resource/validation-results/"
  end

  match "/hierarchy/*path" do
    multi_proxy conn, path, "http://hierarchyapi/hierarchies/"
  end

  match "/concept-relations/*path" do
    multi_proxy conn, path, "http://resource/concept-relations/"
  end

  match "/accounts/*path" do
    multi_proxy conn, path, "http://resource/accounts/"
  end

  match "/users/*path" do
    multi_proxy conn, path, "http://resource/users/"
  end

  match "/groups/*path" do
    multi_proxy conn, path, "http://resource/groups/"
  end

  match "/cache/*path" do
    multi_proxy conn, path, "http://resource/"
  end

  match "/upload/*path" do
    multi_proxy conn, path, "http://importer:8080/upload"
  end

  match "/comments*path" do
    multi_proxy conn, path, "http://commentsapi:8080/"
  end

  match "/kpis/*path" do
    multi_proxy conn, path, "http://kpisapi/kpis/"
  end

  match "/validation/*path" do
    multi_proxy conn, path, "http://validation/"
  end

  match "/validations/*path" do
    multi_proxy conn, path, "http://validation/"
  end

  match "/cleanup/*path" do
    multi_proxy conn, path, "http://cleanup/"
  end

  match "/translate*path" do
    multi_proxy conn, path, "http://dictionary/"
  end
  match "/poetry-tasks/*path" do
    multi_proxy conn, path, "http://resource/poetry-tasks/"
  end
  match "/indexer/*path" do
    multi_proxy conn, path, "http://indexer:8080/"
  end

end