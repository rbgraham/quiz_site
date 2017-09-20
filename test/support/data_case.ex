defmodule QuizSite.DataCase do
  @moduledoc """
  This module defines the setup for tests requiring
  access to the application's data layer.

  You may define functions here to be used as helpers in
  your tests.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      alias QuizSite.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import QuizSite.DataCase
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(QuizSite.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(QuizSite.Repo, {:shared, self()})
    end

    :ok
  end

  @doc """
  A helper that transform changeset errors to a map of messages.

      assert {:error, changeset} = Accounts.create_user(%{password: "short"})
      assert "password is too short" in errors_on(changeset).password
      assert %{password: ["password is too short"]} = errors_on(changeset)

  """
  def errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Enum.reduce(opts, message, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end

  @doc """
  Collect the YAML data for the quiz into some data for testing coverage
  """
  def load_from_yaml do
    load_from_yaml(Application.get_env(:quiz_site, :yaml_data_file))
  end

  def load_from_yaml(filename) do
    File.cwd! 
    |> Path.join("priv/repo/#{filename}")
    |> YamlElixir.read_from_file
  end
end
