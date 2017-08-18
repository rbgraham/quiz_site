defmodule QuizSiteWeb.QuestionView do
  use QuizSiteWeb, :view
  alias QuizSiteWeb.QuestionView

  def render("index.json", %{questions: questions}) do
    %{data: render_many(questions, QuestionView, "question.json")}
  end

  def render("show.json", %{question: question}) do
    %{data: render_one(question, QuestionView, "question.json")}
  end

  def render("question.json", %{question: question}) do
    %{id: question.id,
      question: question.question,
      card_id: question.card_id,
      subtext: question.subtext}
  end
end
