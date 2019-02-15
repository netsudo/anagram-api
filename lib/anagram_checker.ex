defmodule AnagramWeb.AnagramChecker do
  @wordlist "./wordlists/words.txt"

  def anagram?(word1, word2) when is_binary(word1) and is_binary(word2) do
    anagram?(String.to_charlist(word1), String.to_charlist(word2))
  end

  def anagram?(word1, word2) when is_list(word1) and is_list(word2) do
    Enum.sort(word1) === Enum.sort(word2)
  end

  def find_anagrams(word) do
    word = String.trim(word)
    if word != "" do
      case File.open(@wordlist, [:read]) do
        {:ok, file} -> 
          matches = 
            file 
            |> IO.stream(:line) 
            |> Stream.map(&String.trim/1)
            |> Enum.filter(&anagram?(&1, word) && &1 != word)
            {:ok, matches}
        _ -> 
          {:error, "Wordlist not found"}
      end
    else
      {:error, "Must enter a non-empty string"}
    end
  end

  def longest_anagrams() do
    case File.open(@wordlist, [:read]) do
      {:ok, file} -> 
        matches = 
          file 
          |> IO.stream(:line) 
          |> Stream.map(&String.trim/1)
          |> Enum.reduce({0, %{}}, &sort_anagrams/2)
          |> elem(1) # Grab only the map from tuple
          |> Enum.reduce({0, []}, &get_longest/2)
          |> elem(1)
          {:ok, matches}
      _ -> 
        {:error, "Wordlist not found"}
    end
  end

  @doc """
  Goes through the sorted map and checks if the list has at least 2 values.
  If it does that means there's at least one anagram pair. We then check
  if the current length is greater than our longest recorded value. If it's
  larger then the list needs to be cleared so the larger anagrams can replace them.
  If it's the same size they're appended.
  """
  defp get_longest(value_pair, acc) do
    {sorted_word, anagrams} = value_pair
    {longest_anagram_length, items} = acc
    current_word_length = length(sorted_word)

    cond do
      current_word_length > longest_anagram_length  &&
      length(anagrams) > 1   ->
        # Clear list for longer anagrams
        {current_word_length, [] ++ anagrams}

      current_word_length == longest_anagram_length &&
      length(anagrams) > 1   ->
        {current_word_length, items ++ anagrams}

      true -> acc # do nothing
    end
  end

  @doc """
  Check if the current sorted word is in the map. If it is then that means you've
  found an anagram pair, so append it to the value list. Otherwise you add it
  to potentially find another pair later on. Keeping track of longest_anagram_length
  to skip shorter words.
  """
  defp sort_anagrams(word, acc) do
    {longest_anagram_length, items} = acc 
    current_word_length = String.length(word)
    sorted_word = word |> String.to_charlist |> Enum.sort

    cond do
      longest_anagram_length > current_word_length  ->
        acc # do nothing
      longest_anagram_length <= current_word_length ->
        if items[sorted_word] do
          {current_word_length, Map.update!(items, sorted_word, &(&1 ++ [word]))}
        else 
          {longest_anagram_length, Map.put_new(items, sorted_word, [word])}
        end
    end
  end

end
