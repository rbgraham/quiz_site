defmodule QuizSiteWeb.CardView do
  use QuizSiteWeb, :view
  alias QuizSiteWeb.CardView
  require Logger

  def render("index.json", %{cards: cards}) do
    %{data: render_many(cards, CardView, "card.json")}
  end

  def render("show.json", %{card: card}) do
    %{data: render_one(card, CardView, "card.json")}
  end

  def render("card.json", %{card: card}) do
    card = QuizSite.Page.preload_card(card)
    %{id: card.id,
      navigation: card.navigation,
      sequence: card.sequence,
      drip_id: Application.get_env(:quiz_site, :drip_id),
      site: card.site,
      title: card.title,
      questions: render_many(card.questions, QuizSiteWeb.QuestionView, "question.json"),
      sections: render_many(card.sections, QuizSiteWeb.SectionView, "section.json")}
  end
end
