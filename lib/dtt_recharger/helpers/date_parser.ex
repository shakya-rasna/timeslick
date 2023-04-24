defmodule DttRecharger.Helpers.DateParser do

  def convert_string_to_date(date_string) do
    [month, day, year] = String.split(date_string, "/")
    date_string = "20" <> year <> "-" <> String.pad_leading(month, 2, "0") <> "-" <> String.pad_leading(day, 2, "0")
    {:ok, parsed_date} = Date.from_iso8601(date_string)
    parsed_date
  end
end
