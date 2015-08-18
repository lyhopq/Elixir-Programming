defmodule JsonCfgTest do
  use ExUnit.Case
  doctest JsonCfg

  test "data type ok" do
    json = JsonCfg.read
    assert json |> is_list
    assert json |> List.first |> is_tuple
  end

  test "vaule ok" do
    json = JsonCfg.read
    assert json |> List.first |> elem(0) == "employees"

    assert json |> List.first |> elem(1)
    |> List.first |> elem(0)
    |> List.first |> elem(0) == "firstName"

    assert json |> List.first |> elem(1)
    |> List.first |> elem(0)
    |> List.last |> elem(0) == "lastName"
  end

  test "into map ok" do
    json = JsonCfg.read |> Enum.into(Map.new)
    assert json["employees"] |> is_list
    json["employees"] |> List.first |> elem(0)
    |> Enum.into(Map.new) == %{"firstName" => "Bill", "lastName" => "Gates"}
  end
end
