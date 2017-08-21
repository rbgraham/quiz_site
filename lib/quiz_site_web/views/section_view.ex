defmodule QuizSiteWeb.SectionView do
  use QuizSiteWeb, :view
  alias QuizSiteWeb.SectionView

  def render("index.json", %{sections: sections}) do
    %{data: render_many(sections, SectionView, "section.json")}
  end

  def render("show.json", %{section: section}) do
    %{data: render_one(section, SectionView, "section.json")}
  end

  def render("section.json", %{section: section}) do
    section = QuizSite.Cards.preload_section(section)
    %{id: section.id,
      title: section.title,
      content: section.content,
      card_id: section.card_id,
      conditions: render_many(section.conditions, QuizSiteWeb.ConditionView, "condition.json"),
      cta: section.cta}
  end
end
