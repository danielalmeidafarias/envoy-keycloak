-- headers():get(key): Obtém valor de header
-- headers():add(key, value): Adiciona header
-- headers():set(key, value): Define header
-- headers():remove(key): Remove header

-- body(): Retorna corpo da requisição/resposta
-- buffered_body(): Obtém corpo completo
-- body():length(): Tamanho do corpo
-- body():getBytes(start, length): Obtém bytes específicos

-- route(): Acessa informações de roteamento
-- connection(): Detalhes de conexão
-- streamInfo(): Informações do stream

-- headers(): Acessa headers
-- trailers(): Acessa trailers
-- dynamicMetadata(): Manipula metadados dinâmicos

-- logTrace(message): Log de rastreamento
-- logDebug(message): Log de depuração
-- logInfo(message): Log informativo
-- logWarn(message): Log de aviso
-- logErr(message): Log de erro


-- GET /admin/realms/{realm}/users/{user-id}/role-mappings/clients/{client-id}/available


function envoy_on_request(request_handle)
    local jwt_token= request_handle:headers():get("x-jwt-payload")

    local user_id = request_handle:headers():get("x-sub-payload")
    local client_id = request_handle:headers():get("x-azp-payload")
    local resource_access = request_handle:headers():get("x-resource_access-payload")

    local path = request_handle:headers():get(":path")
    local method = request_handle:headers():get(":method")

    request_handle:logInfo("Resource Access: " .. resource_access)
    
    local test = decodeToken(resource_access)
    request_handle:logInfo("Test Access: " .. test)



    -- request_handle:logInfo("Token Jwt: " .. jwt_token)
    -- request_handle:logInfo("UserID: " .. user_id)
    -- request_handle:logInfo("ClientId: " .. client_id)
    -- request_handle:logInfo("Requested Path: " .. path)
    -- request_handle:logInfo("HTTP Method: " .. method)
end
  
-- Called on the response path.
function envoy_on_response(response_handle)

end