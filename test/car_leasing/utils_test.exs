defmodule CarLeasing.UtilsTest do
  use CarLeasingWeb.ConnCase

  import CarLeasing.Utils, only: [is_uuid: 1]

  describe "is_uuid/1" do
    test "returns true for valid UUIDs" do
      assert true == is_uuid("f794cc1e-3c01-4fa3-a817-452cafb91233")
      assert true == is_uuid("01234567-89ab-cdef-0123-456789abcdef")
    end

    test "returns false for invalid UUIDs" do
      assert false == is_uuid("not-a-uuid")
      # Extra character at the end
      assert false == is_uuid("f794cc1e-3c01-4fa3-a817-452cafb91233-")
      # Missing a character at the end
      assert false == is_uuid("f794cc1e-3c01-4fa3-a817-452cafb9123")
    end
  end
end
