defmodule QuizSiteWeb.ChoiceControllerTest do
  use QuizSiteWeb.ConnCase

  alias QuizSite.Questions
  alias QuizSite.Questions.Choice

  @create_attrs %{choice: "some choice"}
  @update_attrs %{choice: "some updated choice"}
  @invalid_attrs %{choice: nil}

  def fixture(:choice) do
    {:ok, choice} = Questions.create_choice(@create_attrs)
    choice
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all choices", %{conn: conn} do
      conn = get conn, choice_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create choice" do
    test "renders choice when data is valid", %{conn: conn} do
      conn = post conn, choice_path(conn, :create), choice: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, choice_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "choice" => "some choice", "image_path" => nil, "microcopy" => true, "score" => 0}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, choice_path(conn, :create), choice: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update choice" do
    setup [:create_choice]

    test "renders choice when data is valid", %{conn: conn, choice: %Choice{id: id} = choice} do
      conn = put conn, choice_path(conn, :update, choice), choice: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, choice_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "choice" => "some updated choice", "image_path" => nil, "microcopy" => true, "score" => 0}
    end

    test "renders errors when data is invalid", %{conn: conn, choice: choice} do
      conn = put conn, choice_path(conn, :update, choice), choice: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete choice" do
    setup [:create_choice]

    test "deletes chosen choice", %{conn: conn, choice: choice} do
      conn = delete conn, choice_path(conn, :delete, choice)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, choice_path(conn, :show, choice)
      end
    end
  end

  defp create_choice(_) do
    choice = fixture(:choice)
    {:ok, choice: choice}
  end
end
