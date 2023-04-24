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

  def downcase(nil), do: nil
end
