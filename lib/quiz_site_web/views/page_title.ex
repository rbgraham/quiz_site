defmodule QuizSiteWeb.PageTitle do
  alias QuizSiteWeb.{ PageView }

  @suffix Application.get_env(:quiz_site, :page_title_suffix)

  def page_title(assigns), do: assigns |> get |> put_suffix

  defp put_suffix(nil), do: @suffix
  defp put_suffix(title), do: title <> " - " <> @suffix

  defp get(%{ view_module: PageView }), do: nil
  defp get(_), do: nil
end
