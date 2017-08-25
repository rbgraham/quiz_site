defmodule QuizSiteWeb.Router do
  use QuizSiteWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", QuizSiteWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/sections", SectionController, except: [:new, :edit]
    resources "/choices", ChoiceController, except: [:new, :edit]
    resources "/questions", QuestionController, except: [:new, :edit]
    resources "/cards", CardController, except: [:new, :edit]
    resources "/conditions", ConditionController, except: [:new, :edit]
    resources "/results", ResultController, except: [:new, :edit]
    resources "/responses", ResponseController, except: [:new, :edit]
  end

  # Other scopes may use custom stacks.
  # scope "/api", QuizSiteWeb do
  #   pipe_through :api
  # end
end
