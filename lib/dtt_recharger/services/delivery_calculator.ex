defmodule DttRecharger.Services.DeliveryDateCalculator do
  import Ecto.Query, warn: false
  alias DttRecharger.Repo
  alias DttRecharger.Schema.Delivery

  def max_delivery_day(number) do
    delivery = from(d in Delivery, where: d.mobile_number == ^number, order_by: [desc: d.delivery_date]) |> Repo.one
    case delivery do
      nil ->
    end
  end
end
