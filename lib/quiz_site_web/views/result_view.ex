defmodule QuizSiteWeb.ResultView do
  use QuizSiteWeb, :view
  alias QuizSiteWeb.ResultView

  def render("index.json", %{results: results}) do
    %{data: render_many(results, ResultView, "result.json")}
  end

  def render("show.json", %{result: result}) do
    %{data: render_one(result, ResultView, "result.json")}
  end

  def render("result.json", %{result: result}) do
    %{id: result.id,
      quiz_name: result.quiz_name}
  end
end
