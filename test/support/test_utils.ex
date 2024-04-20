defmodule Splitmore.TestUtils do
  @moduledoc """
  This module consists test helpers.
  """

  def drop(%{} = struct, fields) when is_list(fields) do
    Map.drop(struct, fields)
  end
end
