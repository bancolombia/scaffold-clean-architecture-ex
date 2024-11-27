defmodule {app}.Utils.DataTypeUtilsTest do
  alias {app}.Utils.DataTypeUtils
  use ExUnit.Case

  describe "normalize/1" do
    test "normalizes a struct" do
      struct = %DateTime{
        year: 2023,
        month: 1,
        day: 1,
        hour: 0,
        minute: 0,
        second: 0,
        time_zone: "Etc/UTC",
        zone_abbr: "UTC",
        utc_offset: 0,
        std_offset: 0
      }

      assert DataTypeUtils.normalize(struct) == struct
    end

    test "normalizes a map" do
      map = %{"key" => "value"}
      assert DataTypeUtils.normalize(map) == %{key: "value"}
    end

    test "normalizes a list" do
      list = [%{"key" => "value"}]
      assert DataTypeUtils.normalize(list) == [%{key: "value"}]
    end
  end

  describe "base64_decode/1" do
    test "decodes a base64 string" do
      assert DataTypeUtils.base64_decode("SGVsbG8gd29ybGQ=") == "Hello world"
    end
  end

  describe "extract_header/2" do
    test "returns {:ok, value} when the header is found and value is not nil" do
      headers = [{"content-type", "application/json"}, {"authorization", "Bearer token"}]
      assert DataTypeUtils.extract_header(headers, "content-type") == {:ok, "application/json"}
    end

    test "returns {:error, :not_found} when the header is not found" do
      headers = [{"content-type", "application/json"}, {"authorization", "Bearer token"}]
      assert DataTypeUtils.extract_header(headers, "accept") == {:error, :not_found}
    end
  end

  describe "extract_header/2 with non-list headers" do
    test "returns an error when headers is a map" do
      headers = %{"content-type" => "application/json"}

      assert DataTypeUtils.extract_header(headers, "content-type") ==
               {:error,
                "headers is not a list when finding \"content-type\": %{\"content-type\" => \"application/json\"}"}
    end

    test "returns an error when headers is a string" do
      headers = "content-type: application/json"

      assert DataTypeUtils.extract_header(headers, "content-type") ==
               {:error,
                "headers is not a list when finding \"content-type\": \"content-type: application/json\""}
    end

    test "returns an error when headers is a tuple" do
      headers = {"content-type", "application/json"}

      assert DataTypeUtils.extract_header(headers, "content-type") ==
               {:error,
                "headers is not a list when finding \"content-type\": {\"content-type\", \"application/json\"}"}
    end

    test "returns an error when headers is nil" do
      headers = nil

      assert DataTypeUtils.extract_header(headers, "content-type") ==
               {:error, "headers is not a list when finding \"content-type\": nil"}
    end

    test "returns an error when headers is an integer" do
      headers = 123

      assert DataTypeUtils.extract_header(headers, "content-type") ==
               {:error, "headers is not a list when finding \"content-type\": 123"}
    end
  end

  describe "format/2" do
    test "returns true when input is 'true' and type is 'boolean'" do
      assert DataTypeUtils.format("true", "boolean") == true
    end

    test "returns false when input is 'false' and type is 'boolean'" do
      assert DataTypeUtils.format("false", "boolean") == false
    end
  end

  test "returns the input value when type is ignored" do
    assert DataTypeUtils.format(123, "any_type") == 123
  end

  test "converts system time in nanoseconds to milliseconds" do
    assert DataTypeUtils.system_time_to_milliseconds(1_000_000_000) == 1000
  end

  test "converts monotonic time in native units to milliseconds" do
    assert DataTypeUtils.monotonic_time_to_milliseconds(1_000_000) == 1
  end

  test "returns different numbers on subsequent calls" do
    {:ok, confirm_number1} = DataTypeUtils.create_confirm_number()
    {:ok, confirm_number2} = DataTypeUtils.create_confirm_number()

    refute confirm_number1 == confirm_number2
  end

  test "returns the current monotonic time as an integer" do
    start_time = DataTypeUtils.start_time()

    assert is_integer(start_time)
  end

  test "calculates the duration time in milliseconds" do
    start_time = System.monotonic_time()
    :timer.sleep(100)
    duration = DataTypeUtils.duration_time(start_time)

    assert is_integer(duration)
    assert duration >= 100
  end
end
