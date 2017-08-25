defmodule QuizSiteWeb.PageController do
  use QuizSiteWeb, :controller

  def index(conn, _params) do
    render conn, "index.html", csrf_token: get_csrf_token()
  end
end
