defmodule DttRecharger.Services.DeliveryHandler do
  import Ecto.Query, warn: false
  import DttRecharger.Helpers.StringParser
  alias DttRecharger.Repo
  alias DttRecharger.Schema.{Delivery, Product}

  def delivery_day(number) do
    delivery = from(d in Delivery,
      left_join: p in Product, on: p.id == d.product_id,
      where: d.mobile_number == ^number, order_by: [desc: p.validity_in_days],
      preload: [:product], limit: 1) |> Repo.one
    case delivery do
      nil ->
        {:ok, delivery_datetime} = NaiveDateTime.new(Date.add(Date.utc_today(), 1), ~T[00:00:00])
        delivery_datetime
      delivery ->
        product_validity_day = delivery.product.validity_in_days
        NaiveDateTime.add(delivery.delivery_date, 60*60*24*(product_validity_day + 1))
    end
  end

  def delivery_params(record) do
    result = []
    times_to_append = String.to_integer(List.first(split_string_by_X(remove_space(record.product_name))))
    for _ <- 1..times_to_append do
      org_id = if is_nil(record.organization), do: nil, else: record.organization.id
      prod_id = if is_nil(record.product), do: nil, else: record.product.id
      result = [%{record_id: record.id, organization_id: org_id,
                  mobile_number: record.mobile_number, product_id: prod_id,
                  delivery_date: delivery_day(record.mobile_number)} | result]
    end
  end
end
