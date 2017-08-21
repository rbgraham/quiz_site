defmodule QuizSiteWeb.ConditionController do
  use QuizSiteWeb, :controller

  alias QuizSite.Sections
  alias QuizSite.Sections.Condition

  action_fallback QuizSiteWeb.FallbackController

  def index(conn, _params) do
    conditions = Sections.list_conditions()
    render(conn, "index.json", conditions: conditions)
  end

  def create(conn, %{"condition" => condition_params}) do
    with {:ok, %Condition{} = condition} <- Sections.create_condition(condition_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", condition_path(conn, :show, condition))
      |> render("show.json", condition: condition)
    end
  end

  def show(conn, %{"id" => id}) do
    condition = Sections.get_condition!(id)
    render(conn, "show.json", condition: condition)
  end

  def update(conn, %{"id" => id, "condition" => condition_params}) do
    condition = Sections.get_condition!(id)

    with {:ok, %Condition{} = condition} <- Sections.update_condition(condition, condition_params) do
      render(conn, "show.json", condition: condition)
    end
  end

  def delete(conn, %{"id" => id}) do
    condition = Sections.get_condition!(id)
    with {:ok, %Condition{}} <- Sections.delete_condition(condition) do
      send_resp(conn, :no_content, "")
    end
  end
end
