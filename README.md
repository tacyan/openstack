# OpenStack

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add openstack to your list of dependencies in `mix.exs`:

        def deps do
          [{:openstack, "~> 0.0.1"}]
        end

  2. Ensure openstack is started before your application:

        def application do
          [applications: [:openstack]]
        end

## Usage

### Authorization Code Flow

REQ

```
curl -i -X POST \
-H "Accept: application/json" \
-d '{"auth":{"passwordCredentials":{"username":"ConoHa","password":"paSSword123456#$%"},"tenantId":"487727e3921d44e3bfe7ebb337bf085e"}}' \
https://identity.tyo1.conoha.io/v2.0/tokens
```

```elixir
# Initialize a client with username, password, tenantId.

client = OpenStack.Client.new(username: "ConoHa",
                              password: "paSSword123456#$%",
                              tenantId: "487727e3921d44e3bfe7ebb337bf085e")

=> %OpenStack.Client{password: "paSSword123456#$%",
                     tenantId: "487727e3921d44e3bfe7ebb337bf085e",
                     token: "",
                     username: "ConoHa"}

OpenStack.Client.get_token("http://example-conoha/v2.0/tokens", client)
=> HTTP/1.1 200 OK
Date: Mon, 08 Dec 2014 02:40:56 GMT
Server: Apache
Content-Length: 4572
Content-Type: application/json

{
  "access": {
    "token": {
      "issued_at": "2015-05-19T07:08:21.927295",
      "expires": "2015-05-20T07:08:21Z",
      "id": "sample00d88246078f2bexample788f7",
      "tenant": {
        "name": "gnct00000000",
        "enabled": true,
        "tyo1_image_size": "550GB",
          }
        ],
        "endpoints_links": [],
        "type": "mailhosting",
        "name": "Mail Hosting Service"
      },
    "user": {
      "username": "gncu00000000",
      "roles_links": [],
      "id": "examplea6963c074d7csample12a886ee",
      "roles": [
        {
          "name": "SwiftOperator"
        },
        {
          "name": "_member_"
        }
      ],
      "name": "gncu00000000"
    },
    "metadata": {
      "is_admin": 0,
      "roles": [
        "0000000000000000000000000000000e",
        "11111111111111111111111111111113"
      ]
    }
  }
}

user = OpenStack.Client.auth_token("http://example-conoha/v2.0/tokens",client)
=> %OpenStack.Client{password: "paSSword123456#$%",
                     tenantId: "487727e3921d44e3bfe7ebb337bf085e",
                     token: "577727e3921d44e3bfe7ebb337bf085e",
                     username: "ConoHa"}

token = user.token

or

token = OpenStack.Client.get_token!("http://example-conoha/v2.0/tokens",client)
=> "577727e3921d44e3bfe7ebb337bf085e"

url = "http://example-conoha/v2/:tenantId/volumes/"

OpenStack.Client.get(url, token, options \\ [])
=> {:ok, %HTTPoison.Response{body: ...}

OpenStack.Client.get!(url, token, options \\ [])
=> {body: ...}

OpenStack.Client.get!(url, token, params: %{options: "options"})
=> []

OpenStack.Client.post(url, body, token, options \\ [])
=> []

OpenStack.Client.post(url, %{ body: "body"}, token, options \\ [])
=> []

OpenStack.Client.put(url, body, token, options \\ [])
=> []

OpenStack.Client.delete(url, token, options \\ [])
=> []
```
