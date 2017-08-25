defmodule QuizSiteWeb.ResponseController do
  use QuizSiteWeb, :controller

  alias QuizSite.Results
  alias QuizSite.Results.Response

  action_fallback QuizSiteWeb.FallbackController

  def index(conn, _params) do
    responses = Results.list_responses()
    render(conn, "index.json", responses: responses)
  end

  def create(conn, %{"response" => response_params}) do
    with {:ok, %Response{} = response} <- Results.create_response(response_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", response_path(conn, :show, response))
      |> render("show.json", response: response)
    end
  end

  def show(conn, %{"id" => id}) do
    response = Results.get_response!(id)
    render(conn, "show.json", response: response)
  end

  def update(conn, %{"id" => id, "response" => response_params}) do
    response = Results.get_response!(id)

    with {:ok, %Response{} = response} <- Results.update_response(response, response_params) do
      render(conn, "show.json", response: response)
    end
  end

  def delete(conn, %{"id" => id}) do
    response = Results.get_response!(id)
    with {:ok, %Response{}} <- Results.delete_response(response) do
      send_resp(conn, :no_content, "")
    end
  end
end
