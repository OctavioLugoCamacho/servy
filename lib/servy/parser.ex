defmodule Servy.Parser do

  alias Servy.Conv

  def parse(request) do
    [top, params_string] = String.split(request,"\r\n\r\n")
    [request_line | header_lines] = String.split(top,"\r\n")
    [method, path, _] = String.split(request_line, " ")

    headers = parse_headers(header_lines, %{})
    params = parse_params(headers["Content-Type"], params_string)

    %Conv{  
      method: method, 
      path: path,
      params: params,
      headers: headers
    }
  end

  @doc """
  Parses the params from a request into a map.
  ## For example:
      iex> params_string = "a=1&b=2&c=3"
      iex> Servy.Parser.parse_params("application/x-www-form-urlencoded", params_string)
      %{"a" => "1", "b" => "2", "c" => "3"}
      iex> Servy.Parser.parse_params("", params_string)
      %{}
  """
  def parse_params("application/x-www-form-urlencoded", params_string) do
    params_string |> String.trim |> URI.decode_query
  end

  def parse_params(_, _), do: %{}

  def parse_headers([head | tail], headers) do
    [key, value] = String.split(head, ": ")
    headers = Map.put(headers, key, value)
    parse_headers(tail, headers)
  end

  def parse_headers([], headers), do: headers
end
