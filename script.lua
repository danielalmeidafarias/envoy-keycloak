function envoy_on_request(request_handle)
    local user_id = request_handle:headers():get("x-sub-payload")
    local client_id = request_handle:headers():get("x-azp-payload")
    local path = request_handle:headers():get(":path")
    local method = request_handle:headers():get(":method")
    local jwt_token = request_handle:headers():get("x-jwt-payload")
    local resource_access = request_handle:headers():get("x-resource_access-payload")
    local required_role = method .. ":" .. path

    local _, client_auth_body = request_handle:httpCall(
        "keycloak_cluster",
        {
            [":method"] = "POST",
            [":authority"] = "localhost:8080",
            [":path"] = "/realms/iezTelecom/protocol/openid-connect/token",
            ["grant_type"] = "client_credentials",
            ["Content-Type"] = "application/x-www-form-urlencoded"
        },
        "client_id=auth&client_secret=HYGyADGbiQfsnYr5ZQZKAuK5D2eubT4T&grant_type=client_credentials",
        5000,
        false
    )

    local cjson = require "cjson"
    local client_token = cjson.decode(client_auth_body).access_token

    local _, client_response_body = request_handle:httpCall(
        "keycloak_cluster",
        {
            [":method"] = "GET",
            [":authority"] = "localhost:8080",
            [":path"] = "/admin/realms/iezTelecom/clients?clientId=" .. client_id,
            ["Authorization"] = "Bearer " .. client_token
        },
        nil,
        5000,
        false
    )

    local client_uuid = cjson.decode(client_response_body)[1].id

    local _, user_roles_response = request_handle:httpCall(
        "keycloak_cluster",
        {
            [":method"] = "GET",
            [":authority"] = "localhost:8080",
            [":path"] = "/admin/realms/iezTelecom/users/" .. user_id .. "/role-mappings/clients/" .. client_uuid,
            ["Authorization"] = "Bearer " .. client_token
        },
        nil,
        5000,
        false
    )

    local user_roles_json_response = cjson.decode(user_roles_response)
    local user_has_role = false

    for _, role in ipairs(user_roles_json_response) do
        request_handle:logInfo(role.name)
        request_handle:logInfo(required_role)
        if role.name == required_role then
            user_has_role = true
        end
    end

    request_handle:logInfo(tostring(user_has_role))

    if not user_has_role then
        request_handle:respond({
            [":status"] = "401",
            ['Content-Type'] = "application/json"
        }, "Don't have the required permissions")
    end
end
