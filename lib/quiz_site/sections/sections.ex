defmodule QuizSite.Sections do
  @moduledoc """
  The Sections context.
  """

  import Ecto.Query, warn: false
  alias QuizSite.Repo

  alias QuizSite.Sections.Condition

  @doc """
  Returns the list of conditions.

  ## Examples

      iex> list_conditions()
      [%Condition{}, ...]

  """
  def list_conditions do
    Repo.all(Condition)
  end

  @doc """
  Gets a single condition.

  Raises `Ecto.NoResultsError` if the Condition does not exist.

  ## Examples

      iex> get_condition!(123)
      %Condition{}

      iex> get_condition!(456)
      ** (Ecto.NoResultsError)

  """
  def get_condition!(id), do: Repo.get!(Condition, id)

  @doc """
  Creates a condition.

  ## Examples

      iex> create_condition(%{field: value})
      {:ok, %Condition{}}

      iex> create_condition(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_condition(attrs \\ %{}) do
    %Condition{}
    |> Condition.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a condition.

  ## Examples

      iex> update_condition(condition, %{field: new_value})
      {:ok, %Condition{}}

      iex> update_condition(condition, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_condition(%Condition{} = condition, attrs) do
    condition
    |> Condition.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Condition.

  ## Examples

      iex> delete_condition(condition)
      {:ok, %Condition{}}

      iex> delete_condition(condition)
      {:error, %Ecto.Changeset{}}

  """
  def delete_condition(%Condition{} = condition) do
    Repo.delete(condition)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking condition changes.

  ## Examples

      iex> change_condition(condition)
      %Ecto.Changeset{source: %Condition{}}

  """
  def change_condition(%Condition{} = condition) do
    Condition.changeset(condition, %{})
  end

  @doc """
  Returns a list of {status, %Condition{}}

  ## Examples
      iex> create_section_and_conditions(%Section{}, %{conditions: [...]})
      [{:ok, %Choice{}}, ...]
  """
  def create_section_and_conditions(section, %{"conditions" => list }) when is_list(list) do
    require Logger
    list
    |> Enum.each(fn (condition) -> create_condition_for_section(section, condition) end)
  end

  def create_section_and_conditions(_, %{ "conditions" => conditions}) do
    require Logger
    Logger.warn "Failed to create conditions: #{inspect(conditions)}"
  end

  def create_section_and_conditions(_, conditions) do
    require Logger
    Logger.warn "Section without conditions: #{inspect(conditions)}"
  end

  @doc """
  Returns a tuple of {status, %Condition{}}

  ## Example
      iex> create_choice_for_section(%Section{}, %{})
      {:ok, %Condition{}}
  """
  def create_condition_for_section(section, %{ "condition" => condition }) do
    import Ecto
    section
    |> build_assoc(:conditions)
    |> Condition.changeset(%{ condition: condition })
    |> Repo.insert
  end

end
