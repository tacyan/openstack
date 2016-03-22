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

	def get_token(url, client) do
  	headers = [{"content-type", "application/json"}]
    HTTPoison.post!(url, request_body(client), headers)
  end

  def auth_token(url, client) do
    token = get_token!(url, client)
    Map.put(client, :token, token)
  end

  def get(url, client) do
    headers = [{"X-Auth-Token", client.token},{"content-type", "application/json"}]
    response = HTTPoison.get!(url, headers)
    |> process_response
  end

end