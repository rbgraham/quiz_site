defmodule QuizSiteWeb.PageController do
  use QuizSiteWeb, :controller

  def index(conn, _params) do
    render conn, "index.html", csrf_token: get_csrf_token()
  end

  def drip_callback(conn, %{"code" => code}) do
    require Logger
    client = get_oauth_client()
    
    url = "https://www.getdrip.com/oauth/token?response_type=token&client_id=#{client.client_id}&client_secret=#{client.client_secret}&code=#{code}&redirect_uri=#{URI.encode_www_form(client.redirect_uri)}&grant_type=authorization_code"
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

  def drip_subscribe(conn, %{"email" => email, "quiz_name" => quiz_name, "score" => score, "result_id" => result_id}) do
    require Logger
    Logger.info "Attempting to subscribe #{inspect(email)}"

    create_drip_subscriber(email, quiz_name, score, result_id)

    send_resp(conn, :no_content, "")
  end

  defp create_drip_subscriber(email, quiz_name, score, result_id) do
    require Logger

    token = QuizSite.Auth.get_drip_token
    subscriber = %{
      "subscribers": [%{
        "email": email,
        "custom_fields": %{
          "quiz_name": quiz_name,
          "score": score,
          "quiz_result_id": result_id
        }
      }]
    }
    url = drip_api_url("subscribers") 
    case HTTPoison.post(url, Poison.encode!(subscriber), [{"Content-Type", "application/vnd.api+json"}, {"Authorization", "Bearer #{token}"}]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Logger.info "Inserted subscriber to Drip: #{inspect(email)} #{inspect(body)}"
        send_drip_event(email, quiz_name, score, result_id)
      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error "Failed to submit new subscriber to Drip: #{inspect(reason)}"
    end
  end

  defp send_drip_event(email, quiz_name, score, result_id) do
    require Logger

    token = QuizSite.Auth.get_drip_token
    event = %{
      "events": [%{
        "email": email,
        "action": "Completed quiz",
        "properties": %{
          "quiz_name": quiz_name,
          "score": score,
        },
        "occurred_at": DateTime.utc_now
      }]
    }
    url = drip_api_url("events")
    case HTTPoison.post(url, Poison.encode!(event), [{"Content-Type", "application/vnd.api+json"}, {"Authorization", "Bearer #{token}"}]) do
      {:ok, %HTTPoison.Response{status_code: 204}} ->
        Logger.info "Sent event to Drip: #{inspect(email)}"
      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error "Failed to submit new event to Drip: #{inspect(reason)}"
    end
  end

  defp drip_api_url(suffix) do
    "https://api.getdrip.com/v2/#{Application.get_env(:quiz_site, :drip_id)}/#{suffix}"
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
