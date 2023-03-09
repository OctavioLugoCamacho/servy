defmodule Servy.Handler do
  def handle(request) do
    request
    |> parse
    |> route
    |> format_response
  end

  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first
      |> String.split(" ")

    %{ method: method, path: path, reso_body: "" }
  end

  def route(_conv) do
    # TODO: Create a new map that also has the response body:
    _conv = %{ method: "GET", path: "/wildthings", reso_body: "Bears, Lions, Tigers" }
  end

  def format_response(_conv) do
    # TODO: Use values in the map to create an HTTP response string:
    """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: 20

    Bears, Lions, Tigers
    """
  end
end

request = """
GET /wildthings HTTP/1.1
Host: example.com
Uer-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts "**************"
IO.puts response
IO.puts "**************"
