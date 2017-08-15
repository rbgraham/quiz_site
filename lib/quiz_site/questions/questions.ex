defmodule QuizSite.Questions do
  @moduledoc """
  The Questions context.
  """

  import Ecto.Query, warn: false
  alias QuizSite.Repo

  alias QuizSite.Questions.Choice

  @doc """
  Returns the list of choices.

  ## Examples

      iex> list_choices()
      [%Choice{}, ...]

  """
  def list_choices do
    Repo.all(Choice)
  end

  @doc """
  Gets a single choice.

  Raises `Ecto.NoResultsError` if the Choice does not exist.

  ## Examples

      iex> get_choice!(123)
      %Choice{}

      iex> get_choice!(456)
      ** (Ecto.NoResultsError)

  """
  def get_choice!(id), do: Repo.get!(Choice, id)

  @doc """
  Creates a choice.

  ## Examples

      iex> create_choice(%{field: value})
      {:ok, %Choice{}}

      iex> create_choice(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_choice(attrs \\ %{}) do
    %Choice{}
    |> Choice.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a choice.

  ## Examples

      iex> update_choice(choice, %{field: new_value})
      {:ok, %Choice{}}

      iex> update_choice(choice, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_choice(%Choice{} = choice, attrs) do
    choice
    |> Choice.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Choice.

  ## Examples

      iex> delete_choice(choice)
      {:ok, %Choice{}}

      iex> delete_choice(choice)
      {:error, %Ecto.Changeset{}}

  """
  def delete_choice(%Choice{} = choice) do
    Repo.delete(choice)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking choice changes.

  ## Examples

      iex> change_choice(choice)
      %Ecto.Changeset{source: %Choice{}}

  """
  def change_choice(%Choice{} = choice) do
    Choice.changeset(choice, %{})
  end

  @doc """
  Returns a list of {status, %Choice{}}

  ## Examples
      iex> create_question_and_choices(%Question{}, %{choices: [...]})
      [{:ok, %Choice{}}, ...]
  """
  def create_question_and_choices(question, %{choices: list }) do
    list
    |> Enum.each(fn (choice) -> create_choice_for_question(question, choice) end)
  end

  @doc """
  Returns a tuple of {status, %Choice{}}

  ## Example
      iex> create_choice_for_question(%Question{}, %{})
      {:ok, %Choice{}}
  """
  def create_choice_for_question(question, choice) do
    import Ecto
    question
    |> build_assoc(:choices)
    |> Choice.changeset(choice)
    |> Repo.insert
  end
end
