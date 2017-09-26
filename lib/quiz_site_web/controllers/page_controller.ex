defmodule QuizSiteWeb.PageController do
  use QuizSiteWeb, :controller

  def index(conn, _params) do
    render conn, "index.html", csrf_token: get_csrf_token()
  end

  def drip_callback(conn, %{"code" => code}) do
    require Logger
    
    client = get_oauth_client()

    Logger.warn "Client for request #{inspect(client)}"
    # Use the authorization code returned from the provider to obtain an access token.
    token = OAuth2.Client.get_token!(client, code: code)

    Logger.warn "OAuth2 client token: #{inspect(token)}"
    # Use the access token to make a request for resources
    #resource = OAuth2.Client.get!(client, "/api/resource").body

    redirect conn, to: "/"
  end

  def drip_auth_init(conn, _params) do
    require Logger
    # Initialize a client with client_id, client_secret, site, and redirect_uri.
    # The strategy option is optional as it defaults to `OAuth2.Strategy.AuthCode`.

    client = get_oauth_client()
    # Generate the authorization URL and redirect the user to the provider.
    url = OAuth2.Client.authorize_url!(client)
    # => "https://auth.example.com/oauth/authorize?client_id=client_id&redirect_uri=https%3A%2F%2Fexample.com%2Fauth%2Fcallback&response_type=code"

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
