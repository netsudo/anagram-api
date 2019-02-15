defmodule AnagramWeb.AnagramControllerTest do
  use AnagramWeb.ConnCase

  @moduledoc """
  Because I'm using a txtfile to store data I can't really utilize the Phoenix
  test suite to its full potential. Typically your application actually makes
  database calls. For testing, when running mix tests, your application would
  create a test db and after every test it'd get rolled back to a fresh state.
  This would allow me to create a fixture for the delete portion and also test
  the create and delete endpoints without touching anything important.

  I figured I could probably solve this by swapping out the txtfile at the
  beginning of the tests and swap it back at the end or do some sort of mocking
  but I felt it'd be overboard for this app.
  """
  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all words", %{conn: conn} do
      conn = get(conn, Routes.anagram_path(conn, :index))
      assert is_list(json_response(conn, 200))
    end
  end

  @doc """ 
  Creating a word that's unlikely to come up organically in the app
  and deleting it in a later test. Easiest way to do it when your apps
  data model is a .txt file although I'm aware it could have unintended
  side effects for users if used in an actual application. 
  """
  describe "create anagram" do
    test "renders anagram when data is valid", %{conn: conn} do
      conn = post(conn, Routes.anagram_path(conn, :create), word: "aabbccddeeffgg123")
      assert json_response(conn, 201)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.anagram_path(conn, :create), word: "")
      assert json_response(conn, 400)["errors"] != %{}
    end
  end

  describe "delete anagram" do
    test "deletes chosen anagram", %{conn: conn} do
      conn = delete(conn, Routes.anagram_path(conn, :delete, word: "aabbccddeeffgg123"))
      assert response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = delete(conn, Routes.anagram_path(conn, :delete), word: "")
      assert json_response(conn, 400)["errors"] != %{}
    end
  end

  describe "compare anagram" do
    test "checks if the anagram is compared properly", %{conn: conn} do
      conn = get(conn, Routes.anagram_path(conn, :compare), word1: "hello", word2: "elloh")
      assert json_response(conn, 200) == true
      conn = get(conn, Routes.anagram_path(conn, :compare), word1: "hello", word2: "hi")
      assert json_response(conn, 200) == false
    end
  end

  describe "longest anagram" do
    test "checks if longset anagram is returning", %{conn: conn} do
      conn = get(conn, Routes.anagram_path(conn, :longest))
      assert is_list(json_response(conn, 200))
    end
  end

  describe "find anagram" do
    test "checks if the find anagram endpoint is functional", %{conn: conn} do
      conn = get(conn, Routes.anagram_path(conn, :find), word: "boon")
      assert response(conn, 200)
      conn = get(conn, Routes.anagram_path(conn, :find), word: "")
      assert json_response(conn, 400)["errors"] != %{}
    end
  end

end
