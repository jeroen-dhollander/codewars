# For the kata, see https://www.codewars.com/kata/554a44516729e4d80b000012
# To run the tests, do elixir -r buying_a_car.ex

defmodule Buycar do
  def nb_months(priceOld, priceNew, savingperMonth, percentLossByMonth) do
    calculate_months(priceOld, priceNew, savingperMonth, percentLossByMonth, 0, 0)
  end

  defp calculate_months(priceOld, priceNew, _, _, numberOfMonths, saved)
       when priceOld + saved >= priceNew do
    {numberOfMonths, round(priceOld + saved - priceNew)}
  end

  defp calculate_months(
         priceOld,
         priceNew,
         savingPerMonth,
         percentLossByMonth,
         numberOfMonths,
         saved
       ) do
    newPercentLossByMonth = new_percent_loss(percentLossByMonth, numberOfMonths)

    calculate_months(
      deprecate(priceOld, newPercentLossByMonth),
      deprecate(priceNew, newPercentLossByMonth),
      savingPerMonth,
      newPercentLossByMonth,
      numberOfMonths + 1,
      saved + savingPerMonth
    )
  end

  defp new_percent_loss(old, month) when rem(month, 2) == 1, do: old + 0.5
  defp new_percent_loss(old, _), do: old

  defp deprecate(old_value, percentLossByMonth), do: old_value * (100 - percentLossByMonth) / 100
end

ExUnit.start()

defmodule BuycarTest do
  use ExUnit.Case

  defp testing(description, startPriceOld, startPriceNew, savingperMonth, percentLossByMonth, ans) do
    IO.puts("Running test #{description}")

    assert Buycar.nb_months(startPriceOld, startPriceNew, savingperMonth, percentLossByMonth) ==
             ans
  end

  test "nb_months" do
    testing("Just enough money from the start", 2000, 2000, 0, 05, {0, 0})
    testing("More than enough money from the start", 2000, 1000, 0, 05, {0, 1000})
    testing("Must save 1 month", 2000, 3000, 1000, 0, {1, 0})
    testing("Must save 1 month and will have money left", 2000, 2500, 1000, 0, {1, 500})
    testing("Interest removes all value in 1 month", 10, 11, 0, 100, {1, 0})
    testing("Must save 2 months (deprecation increases to 0.5%)", 2000, 4000, 1000, 0, {2, 10})
    testing("Two month with interest", 10, 22, 5, 50, {2, 7})
    testing(1, 2000, 8000, 1000, 1.5, {6, 766})
    testing(2, 12000, 8000, 1000, 1.5, {0, 4000})
    testing(3, 8000, 12000, 500, 1, {8, 597})
    testing(4, 18000, 32000, 1500, 1.25, {8, 332})
  end
end
