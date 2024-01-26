config :{app_snake},
  cognito_endpoint: "https://<domain>.auth.<region>.amazoncognito.com/oauth2/token",
  cognito_credentials_provider: {app}.Infrastructure.Adapters.Secrets.SecretManagerAdapter
