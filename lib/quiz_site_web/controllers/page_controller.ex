defmodule QuizSiteWeb.PageController do
  use QuizSiteWeb, :controller

  def index(conn, _params) do
    render conn, "index.html", csrf_token: get_csrf_token()
  end

  def drip_callback(conn, %{"code" => code}) do
    require Logger
    alias QuizSite.Auth.Drip

    client = get_oauth_client()
    
    url = """
    https://www.getdrip.com/oauth/token?response_type=token&client_id=#{client.client_id}&client_secret=#{client.client_secret}&code=#{code}&redirect_uri=#{URI.encode_www_form(client.redirect_uri)}&grant_type=authorization_code
    """
    case HTTPoison.post(url, "", [{"Content-Type", "application/json"}]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> 
        %{ "access_token" => token } = Poison.decode!(body)
        QuizSite.Auth.insert_drip_token(token)
      {:ok, %HTTPoison.Response{status_code: 502, request_url: url}} ->
        Logger.error "Failed to get OAuth token. 502 error at #{inspect(url)}}"
      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error "Failed to get OAuth token at #{url} for #{inspect(reason)}"
    end

    redirect conn, to: "/"
  end

  def drip_auth_init(conn, _params) do
    require Logger
    client = get_oauth_client()
    # Generate the authorization URL and redirect the user to the provider.
    url = OAuth2.Client.authorize_url!(client)

    redirect conn, external: url
  end

  defp get_oauth_client() do
    OAuth2.Client.new([
      strategy: OAuth2.Strategy.AuthCode, #default
      client_id: Application.get_env(:quiz_site, :drip_client_id),
      client_secret: Application.get_env(:quiz_site, :drip_client_secret),
      site: "https://api.getdrip.com/v2/",
      authorize_url: "https://www.getdrip.com/oauth/authorize",
      token_url: "https://www.getdrip.com/oauth/token",
      redirect_uri: "#{Application.get_env(:quiz_site, QuizSiteWeb.Endpoint)[:url][:scheme]}://#{Application.get_env(:quiz_site, QuizSiteWeb.Endpoint)[:url][:host]}/drip/callback"
    ])
  end
end
