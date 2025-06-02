# Rails credentials
Lesli uses rails credentials to manage sensitive application credentials securely. It allows developers to store and access sensitive information, such as API keys, database passwords, and other secrets, in an encrypted format.


#### Manage credentials within Ruby on Rails

```shell
# Ubuntu:
EDITOR="code --wait" rails credentials:edit --environment development
EDITOR="code --wait" rails credentials:edit --environment production
EDITOR="code --wait" rails credentials:edit --environment test
EDITOR="code --wait" rails credentials:edit

# MacOS/Ubuntu server:
EDITOR="nano" rails credentials:edit --environment development
EDITOR="nano" rails credentials:edit --environment production
EDITOR="nano" rails credentials:edit --environment test
EDITOR="nano" rails credentials:edit
```


#### Standard credentials structure for Lesli

Some credentials are required by some engines, this is necessary to work with third-party services like: AWS, Google, Firagase, HoneyBadger, etc. 

```yaml

# Identify your Lesli installation across multiple environments
implementation: "lesli-localhost"

# Standard ruby
db:
    database: ""
    username: ""
    password: ""
    host: "" # optional
    port: "" # optional

# Internal Lesli services
services:

    # Used by LesliDispatcher to sign JWTs
    jwt:
        secret: "your-secret-json-web-token-key"

# Third-party integration keys
providers:

    # AWS Simple Storage Service
    aws_s3: 
        region: eu-central-1
        bucket: ""
        access_key_id: ""
        secret_access_key: ""

    # AWS Simple Email Service
    aws_ses: 
        access_key_id: ""
        secret_access_key: ""
    # AWS Simple Notification Service
    aws_sns: 
        region: eu-central-1
        access_key_id: ""
        secret_access_key: ""

    # Integration with Google services
    google:
        client_id: ""
        client_secret: ""
        maps_sdk_token: ""
        analytics: track_id

    # Firebase, backend and frontend credentials
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

    # Honey badger keys
    honey_badger:
        api_key: ""
        personal_token: ""

# Standard ruby secret
secret_key_base: "your-secret-key-base"
```
