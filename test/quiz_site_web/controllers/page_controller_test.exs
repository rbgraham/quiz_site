defmodule QuizSiteWeb.PageControllerTest do
  use QuizSiteWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Keepify"
  end
end
