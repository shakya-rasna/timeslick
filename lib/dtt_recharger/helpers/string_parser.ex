defmodule DttRecharger.Helpers.StringParser do
  def remove_whitespace(string) do
    Regex.replace(~r/\s+/, string, "")
  end

  def snakecase(string) do
    Macro.underscore(remove_whitespace(string))
  end

  def downcase(string) do
    String.downcase(string)
  end

  def split_string_by_X(string) do
    String.split(string, "X")
  end

  def remove_space(string) do
    String.replace(string, ~r/\s+/, "")
  end
end
