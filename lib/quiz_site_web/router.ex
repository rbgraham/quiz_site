defmodule QuizSiteWeb.Router do
  use QuizSiteWeb, :router

  pipeline :browser do
    plug :accepts, ["html", "json"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", QuizSiteWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/drip/auth", PageController, :drip_auth_init
    get "/drip/callback", PageController, :drip_callback
    resources "/sections", SectionController, except: [:new, :edit]
    resources "/choices", ChoiceController, except: [:new, :edit]
    resources "/questions", QuestionController, except: [:new, :edit]
    resources "/cards", CardController, except: [:new, :edit]
    resources "/conditions", ConditionController, except: [:new, :edit]
    resources "/results", ResultController, except: [:new, :edit]
    resources "/responses", ResponseController, except: [:new, :edit]
  end
end
