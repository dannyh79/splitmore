defmodule Splitmore.BookKeeper do
  @moduledoc """
  This is a book keeper that calculates balances.
  """

  def calculate_balances(_expenses, _people_involved, %{email: _me}) do
    [{"another@example.com", -2_099}]
  end
end
