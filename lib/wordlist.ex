defmodule AnagramWeb.Wordlist do
  @wordlist "./wordlists/words.txt"

  def read_dict() do
    case File.open(@wordlist, [:read]) do
      {:ok, file} -> 
        matches = 
          file 
          |> IO.stream(:line) 
          |> Stream.map(&String.trim/1)
          |> Enum.to_list
          {:ok, matches}
      _ -> 
        {:error, "Wordlist not found"}
    end
  end

  def add_word(word) do
    word = String.trim(word)
    if word != "" do
      File.write(@wordlist, "#{word <> "\n"}", [:append])

    else
      {:error, "Must enter non-empty string"}
    end
  end

  def delete_word(word) do
    word = String.trim(word)
    if word != "" do
      # Replace all instances of word in the wordlist
      case File.write!(@wordlist, File.read!(@wordlist) 
           |> String.replace("#{word <> "\n"}",  "")) do
           :ok -> {:ok, word <> " deleted successfully"}
        _ -> {:error, "Couldn't delete word"}
      end

    else
      {:error, "Must enter non-empty string"}
    end
  end

end
