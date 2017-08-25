defmodule QuizSiteWeb.ResponseView do
  use QuizSiteWeb, :view
  alias QuizSiteWeb.ResponseView

  def render("index.json", %{responses: responses}) do
    %{data: render_many(responses, ResponseView, "response.json")}
  end

  def render("show.json", %{response: response}) do
    %{data: render_one(response, ResponseView, "response.json")}
  end

  def render("response.json", %{response: response}) do
    %{id: response.id,
      choice_id: response.choice_id,
      result_id: response.result_id}
  end
end
