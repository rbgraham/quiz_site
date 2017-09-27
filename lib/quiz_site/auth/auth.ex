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
  def get_drip_token do
    q = from d in Drip,
      where: d.app == "drip",
      order_by: [desc: d.id],
      limit: 1,
      select: d.token
    Repo.one(q)
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
