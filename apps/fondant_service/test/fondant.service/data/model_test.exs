defmodule Fondant.Service.Data.ModelTest do
    use Fondant.Service.Case

    alias Fondant.Service.Data

    @valid_model %Data.Model{ timestamp: "0" }

    test "empty" do
        refute_change(%Data.Model{})
    end

    test "only timestamp" do
        assert_change(%Data.Model{}, %{ timestamp: "1" })
        |> assert_change_value(:timestamp, "1")
    end

    test "timestamp length" do
        refute_change(@valid_model, %{ timestamp: "" })
        assert_change(@valid_model, %{ timestamp: "1" })
        assert_change(@valid_model, %{ timestamp: "11" })
    end

    test "timestamp format" do
        refute_change(@valid_model, %{ timestamp: "a" })
        refute_change(@valid_model, %{ timestamp: "1a" })
        refute_change(@valid_model, %{ timestamp: "a1" })
        assert_change(@valid_model, %{ timestamp: "11" })
    end
end
