defmodule QuizSiteWeb.ResultController do
  use QuizSiteWeb, :controller

  alias QuizSite.Questions
  alias QuizSite.Questions.Result

  action_fallback QuizSiteWeb.FallbackController

  def index(conn, _params) do
    results = Questions.list_results()
    render(conn, "index.json", results: results)
  end

  def create(conn, %{"result" => result_params}) do
    with {:ok, %Result{} = result} <- Questions.create_result(result_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", result_path(conn, :show, result))
      |> render("show.json", result: result)
    end
  end

  def show(conn, %{"id" => id}) do
    result = Questions.get_result!(id)
    render conn, "show." <> get_format(conn), result: result, csrf_token: get_csrf_token()
  end

  def update(conn, %{"id" => id, "result" => result_params}) do
    result = Questions.get_result!(id)

    with {:ok, %Result{} = result} <- Questions.update_result(result, result_params) do
      render(conn, "show.json", result: result)
    end
  end

  def delete(conn, %{"id" => id}) do
    result = Questions.get_result!(id)
    with {:ok, %Result{}} <- Questions.delete_result(result) do
      send_resp(conn, :no_content, "")
    end
  end
end
