defmodule QuizSiteWeb.ChoiceController do
  use QuizSiteWeb, :controller

  alias QuizSite.Questions
  alias QuizSite.Questions.Choice

  action_fallback QuizSiteWeb.FallbackController

  def index(conn, _params) do
    choices = Questions.list_choices()
    render(conn, "index.json", choices: choices)
  end

  def create(conn, %{"choice" => choice_params}) do
    with {:ok, %Choice{} = choice} <- Questions.create_choice(choice_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", choice_path(conn, :show, choice))
      |> render("show.json", choice: choice)
    end
  end

  def show(conn, %{"id" => id}) do
    choice = Questions.get_choice!(id)
    render(conn, "show.json", choice: choice)
  end

  def update(conn, %{"id" => id, "choice" => choice_params}) do
    choice = Questions.get_choice!(id)

    with {:ok, %Choice{} = choice} <- Questions.update_choice(choice, choice_params) do
      render(conn, "show.json", choice: choice)
    end
  end

  def delete(conn, %{"id" => id}) do
    choice = Questions.get_choice!(id)
    with {:ok, %Choice{}} <- Questions.delete_choice(choice) do
      send_resp(conn, :no_content, "")
    end
  end
end
