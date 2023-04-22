defmodule DttRecharger.Helpers.CsvParser do

  alias DttRecharger.Helpers.StringParser

  def parse_csv(path, content_type) do
    if content_type == "text/csv" do
      data = csv_decoder(path)
      convert_params(data)
    end
  end

  defp csv_decoder(path) do
    path
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> CSV.decode(headers: true)
    |> Enum.map(fn {:ok, data} -> data end)
  end

  defp convert_params(decoded_datas) do
    decoded_datas
    |> Enum.map(fn datas ->
      datas
      |> Enum.map(fn data -> data end)
      |> Enum.map(fn {key, value} -> {StringParser.snakecase(key), value} end)
      |> Enum.into(%{})
      |> convert()
    end)
  end

  defp convert(data) do
    for {key, val} <- data, into: %{}, do: {String.to_atom(key), val}
  end
end
