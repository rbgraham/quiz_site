defmodule QuizSiteWeb.ConditionView do
  use QuizSiteWeb, :view
  alias QuizSiteWeb.ConditionView

  def render("index.json", %{conditions: conditions}) do
    %{data: render_many(conditions, ConditionView, "condition.json")}
  end

  def render("show.json", %{condition: condition}) do
    %{data: render_one(condition, ConditionView, "condition.json")}
  end

  def render("condition.json", %{condition: condition}) do
    %{id: condition.id,
      condition: condition.condition,
      section: condition.section_id }
  end
end
