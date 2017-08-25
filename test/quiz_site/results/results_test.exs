defmodule QuizSite.ResultsTest do
  use QuizSite.DataCase

  alias QuizSite.Results

  describe "responses" do
    alias QuizSite.Results.Response

    @valid_attrs %{choice_id: 42, result_id: 42}
    @update_attrs %{choice_id: 43, result_id: 43}
    @invalid_attrs %{choice_id: nil, result_id: nil}

    def response_fixture(attrs \\ %{}) do
      {:ok, response} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Results.create_response()

      response
    end

    test "list_responses/0 returns all responses" do
      response = response_fixture()
      assert Results.list_responses() == [response]
    end

    test "get_response!/1 returns the response with given id" do
      response = response_fixture()
      assert Results.get_response!(response.id) == response
    end

    test "create_response/1 with valid data creates a response" do
      assert {:ok, %Response{} = response} = Results.create_response(@valid_attrs)
      assert response.choice_id == 42
      assert response.result_id == 42
    end

    test "create_response/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Results.create_response(@invalid_attrs)
    end

    test "update_response/2 with valid data updates the response" do
      response = response_fixture()
      assert {:ok, response} = Results.update_response(response, @update_attrs)
      assert %Response{} = response
      assert response.choice_id == 43
      assert response.result_id == 43
    end

    test "update_response/2 with invalid data returns error changeset" do
      response = response_fixture()
      assert {:error, %Ecto.Changeset{}} = Results.update_response(response, @invalid_attrs)
      assert response == Results.get_response!(response.id)
    end

    test "delete_response/1 deletes the response" do
      response = response_fixture()
      assert {:ok, %Response{}} = Results.delete_response(response)
      assert_raise Ecto.NoResultsError, fn -> Results.get_response!(response.id) end
    end

    test "change_response/1 returns a response changeset" do
      response = response_fixture()
      assert %Ecto.Changeset{} = Results.change_response(response)
    end
  end
end
