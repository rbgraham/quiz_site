defmodule QuizSite.Cards.Section do
  use Ecto.Schema
  import Ecto.Changeset
  alias QuizSite.Cards.Section


  schema "sections" do
    field :content, :string
    field :cta, :string
    field :title, :string
    field :image_path, :string
    field :image_width, :string
    field :email_form, :boolean
    field :share, :boolean
    field :share_text, :string
    field :skip_button, :boolean
    field :result_display, :boolean

    belongs_to :card, QuizSite.Page.Card
    has_many :conditions, QuizSite.Sections.Condition

    timestamps()
  end

  @doc false
  def changeset(%Section{} = section, attrs) do
    section
    |> cast(attrs, [:title, :content, :cta, :image_path, :image_width, :email_form, :share, :share_text, :skip_button, :result_display])
    |> validate_required([:title, :content])
  end
end
