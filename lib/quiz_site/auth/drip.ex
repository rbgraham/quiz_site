defmodule QuizSite.Auth.Drip do
  use Ecto.Schema
  import Ecto.Changeset
  alias QuizSite.Auth.Drip


  schema "oauths" do
    field :app, :string
    field :expiration, :date
    field :token, :string

    timestamps()
  end

  @doc false
  def changeset(%Drip{} = drip, attrs) do
    drip
    |> cast(attrs, [:app, :expiration, :token])
    |> validate_required([:token, :app])
  end
end

