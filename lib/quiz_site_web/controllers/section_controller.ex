defmodule QuizSiteWeb.SectionController do
  use QuizSiteWeb, :controller

  alias QuizSite.Cards
  alias QuizSite.Cards.Section

  action_fallback QuizSiteWeb.FallbackController

  def index(conn, _params) do
    sections = Cards.list_sections()
    render(conn, "index.json", sections: sections)
  end

  def create(conn, %{"section" => section_params}) do
    with {:ok, %Section{} = section} <- Cards.create_section(section_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", section_path(conn, :show, section))
      |> render("show.json", section: section)
    end
  end

  def show(conn, %{"id" => id}) do
    section = Cards.get_section!(id)
    render(conn, "show.json", section: section)
  end

  def update(conn, %{"id" => id, "section" => section_params}) do
    section = Cards.get_section!(id)

    with {:ok, %Section{} = section} <- Cards.update_section(section, section_params) do
      render(conn, "show.json", section: section)
    end
  end

  def delete(conn, %{"id" => id}) do
    section = Cards.get_section!(id)
    with {:ok, %Section{}} <- Cards.delete_section(section) do
      send_resp(conn, :no_content, "")
    end
  end
end
