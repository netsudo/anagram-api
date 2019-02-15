defmodule AnagramWeb.AnagramController do
  use AnagramWeb, :controller
  import AnagramWeb.{AnagramChecker, Wordlist}
  alias AnagramWeb.ErrorView

  action_fallback AnagramWeb.FallbackController

  def compare(conn, %{"word1" => word1, "word2" => word2}) do
    anagram_status = anagram?(word1, word2)
    render(conn, "success.json", %{message: anagram_status})
  end

  def find(conn, %{"word" => word}) do
    case find_anagrams(word) do
      {:ok, matches} -> 
        render(conn, "success.json", %{message: matches})
      {:error, msg}  -> 
        put_status(conn, 400)
        |> put_view(ErrorView)
        |> render("file.json", %{error: msg})
    end
  end

  def longest(conn, _params) do
    case longest_anagrams() do
      {:ok, matches} -> 
        render(conn, "success.json", %{message: matches})
      {:error, msg}  -> 
        put_status(conn, 400)
        |> put_view(ErrorView)
        |> render("file.json", %{error: msg})
    end
  end

  def index(conn, _params) do
    case read_dict() do
      {:ok, dict} -> 
        render(conn, "success.json", %{message: dict})
      {:error, msg}  -> 
        put_status(conn, 400)
        |> put_view(ErrorView)
        |> render("file.json", %{error: msg})
    end
  end

  def create(conn, %{"word" => word}) do
    case add_word(word) do
      :ok -> 
        put_status(conn, :created)
        |> render("success.json", %{message: "Word added successfully"})
      {:error, msg} -> 
        put_status(conn, 400)
        |> put_view(ErrorView)
        |> render("file.json", %{error: msg})
    end
  end

  def delete(conn, %{"word" => word}) do
    case delete_word(word) do
      {:ok, msg} -> 
        put_status(conn, 200)
        |> render("success.json", %{message: msg})
      {:error, msg} -> 
        put_status(conn, 400)
        |> put_view(ErrorView)
        |> render("file.json", %{error: msg})
    end
  end

end
