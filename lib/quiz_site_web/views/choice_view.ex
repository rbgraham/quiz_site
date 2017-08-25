defmodule QuizSiteWeb.ChoiceView do
  use QuizSiteWeb, :view
  alias QuizSiteWeb.ChoiceView

  def render("index.json", %{choices: choices}) do
    %{data: render_many(choices, ChoiceView, "choice.json")}
  end

  def render("show.json", %{choice: choice}) do
    %{data: render_one(choice, ChoiceView, "choice.json")}
  end

  def render("choice.json", %{choice: choice}) do
    %{id: choice.id,
      image_path: choice.image_path,
      microcopy: choice.microcopy,
      choice: choice.choice}
  end
end
