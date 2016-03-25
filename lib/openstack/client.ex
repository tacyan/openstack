defmodule OpenStack.Client do
  defstruct username: "",
            password: "",
            tenantId: "",
            token:    ""

  def new(opts), do: struct(__MODULE__, opts)

  def request_body(client) do
    %{auth:
      %{tenantId: client.tenantId,
        passwordCredentials: %{
          username: client.username,
          password: client.password
        }
      }
    }
    |> Poison.encode!
  end

  def get_token!(url, client) do
    headers = [{"content-type", "application/json"}]
    HTTPoison.post!(url, request_body(client), headers)
    |> get_token_process_response
  end

  def get_token_process_response(%{status_code: 200, body: body}) do
    body
    |> Poison.decode!
    |> auth_token
  end

  def process_response(%{status_code: 200, body: body}) do
    body
    |> Poison.decode!
  end

  def auth_token(body) do
    Map.get(body, "access")
    |> Map.get("token")
    |> Map.get("id")
  end

  def auth_token(url, client) do
    token = get_token!(url, client)
    Map.put(client, :token, token)
  end

  def get_token(url, client) do
    headers = [{"content-type", "application/json"}]
    HTTPoison.post!(url, request_body(client), headers)
  end

  def get(url, token, options \\ []) do
    headers = [{"X-Auth-Token", token},{"content-type", "application/json"}]
    HTTPoison.get(url, headers, options)
  end

  def get!(url, token, options \\ []) do
    headers = [{"X-Auth-Token", token},{"content-type", "application/json"}]
    HTTPoison.get!(url, headers, options)
    |> process_response
  end

  def post(url, body, token, options \\ []) do
    headers = [{"X-Auth-Token", token},{"content-type", "application/json"}]
    HTTPoison.post(url, body |> Poison.encode!, headers, options)
  end

  def post!(url, body, token, options \\ []) do
    headers = [{"X-Auth-Token", token},{"content-type", "application/json"}]
    HTTPoison.post!(url, body |> Poison.encode!, headers, options)
  end

  def put(url, body, token, options \\ []) do
    headers = [{"X-Auth-Token", token},{"content-type", "application/json"}]
    HTTPoison.put(url, body |> Poison.encode!, headers, options)
  end

  def put!(url, body, token, options \\ []) do
    headers = [{"X-Auth-Token", token},{"content-type", "application/json"}]
    HTTPoison.put!(url, body |> Poison.encode!, headers, options)
  end

  def delete(url, token, options \\ []) do
    headers = [{"X-Auth-Token", token},{"content-type", "application/json"}]
    HTTPoison.delete(url, headers, options)
  end

  def delete!(url, token, options \\ []) do
    headers = [{"X-Auth-Token", token},{"content-type", "application/json"}]
    HTTPoison.delete!(url, headers, options)
  end

end
