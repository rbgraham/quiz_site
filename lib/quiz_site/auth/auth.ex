defmodule QuizSite.Auth do
  @moduledoc """
  The Auth context.
  """

  import Ecto.Query, warn: false
  alias QuizSite.Repo

  alias QuizSite.Auth.Drip

  @doc """
  Returns the latest of token.
  """
  def get_token do
    Repo.first(Drip)
  end

  @doc """
  Insert a new token
  """
  def insert_drip_token(token) do
    attrs = %{token: token, app: "drip"}

    %Drip{}
    |> Drip.changeset(attrs)
    |> Repo.insert()
  end
end
