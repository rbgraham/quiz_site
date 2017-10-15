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
    question = QuizSite.Cards.preload_question(question)
    %{id: question.id,
      question: question.question,
      card_id: question.card_id,
      preserve_order: question.preserve_order,
      choices: render_many(question.choices, QuizSiteWeb.ChoiceView, "choice.json"),
      subtext: question.subtext}
  end
end
