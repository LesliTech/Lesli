# Rails Credentials in Lesli

Lesli uses **Rails Credentials** to securely manage sensitive configuration values across environments. This ensures credentials such as API keys, database passwords, and third-party service tokens remain encrypted and safe.

---

## Managing Rails Credentials

To edit credentials for a specific environment, use the following commands:

### Ubuntu / Linux Desktop

```shell
EDITOR="code --wait" rails credentials:edit --environment development
EDITOR="code --wait" rails credentials:edit --environment production
EDITOR="code --wait" rails credentials:edit --environment test
EDITOR="code --wait" rails credentials:edit
```

### macOS / Ubuntu Server

```shell
EDITOR="nano" rails credentials:edit --environment development
EDITOR="nano" rails credentials:edit --environment production
EDITOR="nano" rails credentials:edit --environment test
EDITOR="nano" rails credentials:edit
```

> These commands will open the encrypted credentials file in your chosen editor.s


## Recommended Credentials Structure for Lesli

Some Lesli modules (engines) require specific credentials to integrate with third-party services like AWS, Google, Firebase, Honeybadger, and others. Below is a suggested structure for organizing your credentials.

```yml
# Identify your Lesli installation across environments
implementation: "lesli-localhost"

# Database credentials (standard Ruby)
db:
    database: ""
    username: ""
    password: ""
    host: ""   # Optional
    port: ""   # Optional

# Internal Lesli services
services:
    jwt:
        secret: "your-secret-json-web-token-key" # Used by LesliDispatcher to sign JWTs

# Third-party integration keys
providers:
    # AWS Simple Storage Service (S3)
    aws_s3: 
        region: eu-central-1
        bucket: ""
        access_key_id: ""
        secret_access_key: ""

    # AWS Simple Email Service (SES)
    aws_ses: 
        access_key_id: ""
        secret_access_key: ""

    # AWS Simple Notification Service (SNS)
    aws_sns: 
        region: eu-central-1
        access_key_id: ""
        secret_access_key: ""

    # Google Cloud integrations
    google:
        client_id: ""
        client_secret: ""
        maps_sdk_token: ""
        tag_manager: ""

    # Firebase credentials (backend & frontend)
    firebase:
        api_key: ""
        admin_sdk_private_key:
            type: ""
            project_id: ""
            private_key_id: ""
            private_key: ""
            client_email: ""
            client_id: ""
            auth_uri: ""
            token_uri: ""
            auth_provider_x509_cert_url: ""
            client_x509_cert_url: ""
        web:
            apiKey: ""
            authDomain: ""
            projectId: ""
            storageBucket: ""
            messagingSenderId: ""
            appId: ""

    # Honeybadger error tracking
    honey_badger:
        api_key: ""
        personal_token: ""

# Rails secret key base
secret_key_base: "your-secret-key-base"
```

## Overriding Credentials with Environment Variables

Most credentials stored in your Rails encrypted credentials file can be **overridden using environment variables**. This is useful for configuring secrets per environment (development, staging, production) without modifying your encrypted files.

### Environment Variable Format

Use the following naming convention (all **uppercase**):

LESLI\_{SECTION}\_{GROUP}\_{KEY}


Where:
- **LESLI** is the fixed prefix.
- **SECTION** matches the top-level namespace in your credentials (e.g., `PROVIDERS`, `SERVICES`).
- **GROUP** is the specific integration or category within the section (e.g., `HONEY_BADGER`, `AWS_S3`).
- **KEY** is the specific credential key (e.g., `API_KEY`, `ACCESS_KEY_ID`).

---

### Example

If your credentials file includes:

```yaml
providers:
    honey_badger:
        api_key: "my-api-key"
```

You can override this at runtime by setting the following environment variable:

```shell
LESLI_PROVIDERS_HONEY_BADGER_API_KEY="my-super-secret-api-key"
```

Why Use ENV Variables?

- Easily configure secrets per environment (development, staging, production).
- Keep sensitive information out of version control.
- Useful for Docker, CI/CD pipelines, and cloud-hosted environments.
