# Ensure APISIX service running
curl "http://127.0.0.1:9180/apisix/admin/services/" -H 'X-API-KEY: edd1c9f034335f136f87ad84b625c8f1'

# Create upstreams for REMOTE backend app
curl "http://127.0.0.1:9180/apisix/admin/upstreams/api-conteudos" \
-H "X-API-KEY: edd1c9f034335f136f87ad84b625c8f1" -X PUT -d '
{
  "name": "Azure - Api Conteudos",
  "type": "roundrobin",
  "scheme": "https",
  "nodes": {
    "apiconteudosdev.ashyflower-2dacb592.westus2.azurecontainerapps.io:443": 1
  }
}'

# Create route for backend app (With reverse proxy)
curl "http://127.0.0.1:9180/apisix/admin/routes/conteudos-a" \
-H "X-API-KEY: edd1c9f034335f136f87ad84b625c8f1" -X PUT -d '
{
    "name": "Conteudos - Categoria A",
    "methods": ["GET"],
    "uri": "/api/v1/conteudos/a",
    "plugins": {
        "proxy-rewrite": {
            "host": "apiconteudosdev.ashyflower-2dacb592.westus2.azurecontainerapps.io:443",
            "scheme": "https"
        }
    },
    "upstream_id": "api-conteudos"
}'


# curl -i -X GET "http://127.0.0.1:9080/api/v1/conteudos/a"
