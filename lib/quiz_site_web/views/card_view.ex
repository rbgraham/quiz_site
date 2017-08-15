defmodule QuizSiteWeb.CardView do
  use QuizSiteWeb, :view
  alias QuizSiteWeb.CardView

  def render("index.json", %{cards: cards}) do
    %{data: render_many(cards, CardView, "card.json")}
  end

  def render("show.json", %{card: card}) do
    %{data: render_one(card, CardView, "card.json")}
  end

  def render("card.json", %{card: card}) do
    %{id: card.id,
      navigation: card.navigation,
      sequence: card.sequence,
      site: card.site,
      title: card.title}
  end
end
