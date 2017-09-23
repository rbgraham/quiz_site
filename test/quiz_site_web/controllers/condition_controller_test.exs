defmodule QuizSiteWeb.ConditionControllerTest do
  use QuizSiteWeb.ConnCase

  alias QuizSite.Sections
  alias QuizSite.Sections.Condition

  @create_attrs %{condition: "some condition", section_id: 42}
  @update_attrs %{condition: "some updated condition", section_id: 43}
  @invalid_attrs %{condition: nil, section_id: nil}

  def fixture(:condition) do
    {:ok, condition} = Sections.create_condition(@create_attrs)
    condition
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all conditions", %{conn: conn} do
      conn = get conn, condition_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create condition" do
    test "renders condition when data is valid", %{conn: conn} do
      conn = post conn, condition_path(conn, :create), condition: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, condition_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "condition" => "some condition", "equal_to" => nil, "greater_than" => nil, "less_than" => nil,
        "section_id" => 42}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, condition_path(conn, :create), condition: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update condition" do
    setup [:create_condition]

    test "renders condition when data is valid", %{conn: conn, condition: %Condition{id: id} = condition} do
      conn = put conn, condition_path(conn, :update, condition), condition: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, condition_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "condition" => "some updated condition", "equal_to" => nil, "greater_than" => nil, "less_than" => nil,
        "section_id" => 43}
    end

    test "renders errors when data is invalid", %{conn: conn, condition: condition} do
      conn = put conn, condition_path(conn, :update, condition), condition: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete condition" do
    setup [:create_condition]

    test "deletes chosen condition", %{conn: conn, condition: condition} do
      conn = delete conn, condition_path(conn, :delete, condition)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, condition_path(conn, :show, condition)
      end
    end
  end

  defp create_condition(_) do
    condition = fixture(:condition)
    {:ok, condition: condition}
  end
end
