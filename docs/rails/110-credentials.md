
# Rails credentials


```bash
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
````


__Credentials file structure:__
```
RailsApp/config/credentials/development.yml  

instance: "lesli-localhost"
db:
    database: ""
    username: ""
    password: ""
    host: "" # optional
    port: "" # optional
services:
    jwt:
        secret: "your-secret-json-web-token-key"
providers:
    aws:
        region: eu-central-1
        bucket: ""
        access_key_id: ""
        secret_access_key: ""
        s3: (optional)
            region: eu-central-1
            bucket: ""
            access_key_id: ""
            secret_access_key: ""
        ses: (optional sdk or stmp)
            access_key_id: ""
            secret_access_key: ""
        sns: (optional)
            region: eu-central-1
            access_key_id: ""
            secret_access_key: ""
    google:
        maps_sdk_token: ""
        analytics: track_id
        client_id: ""
        client_secret: ""
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
    facebook:
        client_id: ""
        client_secret: ""
    honey_badger:
        api_key: ""
        personal_token: ""
    mailgun:
        smtp:
            port: 587
            address: "smtp.mailgun.org"
            user_name: ""
            password: ""
    motomo: site_id
secret_key_base: "your-secret-key-base"
```


__Example for development:__
```
instance: "lesli-localhost"
db:
    database: "database_name"
    username: "database_user"
    password: "database_pass"
services:
    jwt:
        secret: "your-secret-json-web-token-key"
providers:
    aws:
        region: eu-central-1
        bucket: ""
        access_key_id: ""
        secret_access_key: ""
        s3:
            region: eu-central-1
            bucket: ""
            access_key_id: ""
            secret_access_key: ""
    google:
        maps_sdk_token: ""
    honey_badger:
        api_key: ""
        personal_token: ""
    motomo: 0
secret_key_base: "your-secret-key-base"
```
