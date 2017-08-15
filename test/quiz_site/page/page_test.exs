defmodule QuizSite.PageTest do
  use QuizSite.DataCase

  alias QuizSite.Page

  describe "cards" do
    alias QuizSite.Page.Card

    @valid_attrs %{navigation: "some navigation", title: "some title"}
    @update_attrs %{navigation: "some updated navigation", title: "some updated title"}
    @invalid_attrs %{navigation: nil, title: nil}

    def card_fixture(attrs \\ %{}) do
      {:ok, card} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Page.create_card()

      card
    end

    test "list_cards/0 returns all cards" do
      card = card_fixture()
      assert Page.list_cards() == [card]
    end

    test "get_card!/1 returns the card with given id" do
      card = card_fixture()
      assert Page.get_card!(card.id) == card
    end

    test "create_card/1 with valid data creates a card" do
      assert {:ok, %Card{} = card} = Page.create_card(@valid_attrs)
      assert card.navigation == "some navigation"
      assert card.title == "some title"
    end

    test "create_card/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Page.create_card(@invalid_attrs)
    end

    test "update_card/2 with valid data updates the card" do
      card = card_fixture()
      assert {:ok, card} = Page.update_card(card, @update_attrs)
      assert %Card{} = card
      assert card.navigation == "some updated navigation"
      assert card.title == "some updated title"
    end

    test "update_card/2 with invalid data returns error changeset" do
      card = card_fixture()
      assert {:error, %Ecto.Changeset{}} = Page.update_card(card, @invalid_attrs)
      assert card == Page.get_card!(card.id)
    end

    test "delete_card/1 deletes the card" do
      card = card_fixture()
      assert {:ok, %Card{}} = Page.delete_card(card)
      assert_raise Ecto.NoResultsError, fn -> Page.get_card!(card.id) end
    end

    test "change_card/1 returns a card changeset" do
      card = card_fixture()
      assert %Ecto.Changeset{} = Page.change_card(card)
    end
  end
end
