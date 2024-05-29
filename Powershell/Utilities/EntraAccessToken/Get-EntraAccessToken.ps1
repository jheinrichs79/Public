# Define your app registration details
$tenantId = "<your-tenant-id>"
$clientId = "<your-client-id>"
$clientSecret = "<your-client-secret>"
$resourceUri = "https://graph.microsoft.com"  # Replace with your desired resource
$uri = "https://login.microsoftonline.com/$tenantId/oauth2/token"

# Construct the token request
$tokenRequestBody = @{
    grant_type    = "client_credentials"
    client_id     = $clientId
    client_secret = $clientSecret
    resource      = $resourceUri
}

# Send a POST request to the identity platform
$tokenResponse = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$tenantId/oauth2/token" -Method POST -ContentType "application/x-www-form-urlencoded" -Body $tokenRequestBody

# Extract the access token
$accessToken = $tokenResponse.access_token

# Now you can use $accessToken in your API requests
Write-Host "Access token: $accessToken"
