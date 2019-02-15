defmodule AnagramWeb.AnagramView do
  use AnagramWeb, :view

  def render("success.json", %{message: message}) do
    message
  end

end
