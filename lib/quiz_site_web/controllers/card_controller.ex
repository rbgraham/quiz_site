defmodule QuizSiteWeb.CardController do
  use QuizSiteWeb, :controller

  alias QuizSite.Page
  alias QuizSite.Page.Card

  action_fallback QuizSiteWeb.FallbackController

  def index(conn, _params) do
    cards = Page.list_cards()
    render(conn, "index.json", cards: cards)
  end

  def create(conn, %{"card" => card_params}) do
    with {:ok, %Card{} = card} <- Page.create_card(card_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", card_path(conn, :show, card))
      |> render("show.json", card: card)
    end
  end

  def show(conn, %{"id" => id}) do
    card = Page.get_card!(id)
    render(conn, "show.json", card: card)
  end

  def update(conn, %{"id" => id, "card" => card_params}) do
    card = Page.get_card!(id)

    with {:ok, %Card{} = card} <- Page.update_card(card, card_params) do
      render(conn, "show.json", card: card)
    end
  end

  def delete(conn, %{"id" => id}) do
    card = Page.get_card!(id)
    with {:ok, %Card{}} <- Page.delete_card(card) do
      send_resp(conn, :no_content, "")
    end
  end
end
