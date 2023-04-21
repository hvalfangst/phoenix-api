defmodule CarLeasing.Utils do
  defmacro is_uuid(value) do
    quote do
      # Checks whether `value` is a binary and whether its byte size is 36 (UUIDs are typically represented as a 36-character string)
      # Checks that the 9th, 14th, 19th, and 24th characters are "-" characters, as specified in the UUID format
      is_binary(unquote(value)) and byte_size(unquote(value)) == 36 and
        binary_part(unquote(value), 8, 1) == "-" and binary_part(unquote(value), 13, 1) == "-" and
        binary_part(unquote(value), 18, 1) == "-" and binary_part(unquote(value), 23, 1) == "-"
    end
  end
end
