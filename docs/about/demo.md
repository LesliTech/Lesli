# Explore Lesli in Action

## Online Demo

Experience the full capabilities of the **Lesli Platform** through our live demo:

[https://demo.lesli.dev](https://demo.lesli.dev)

> **Please note:**  
> - This is a public demo instance provided for evaluation purposes.  
> - LesliTech is **not responsible** for any data stored in this environment.  
> - The demo environment is **reset every 24 hours** to ensure performance and integrity.


<br/>

## Create a demo app using a Rails template

```shell
# Use the Rails template
rails new LesliDemo -m lesli_demo.rb --skip-bundle
```


<br/>

## Install Lesli manually

```shell
# Add Lesli engine
bundle add lesli

# Add Lesli to your app
rails generate lesli:install

# Setup database for development
rake lesli:db:reset

# Start your app
rails server
```


<br/>

## Running Lesli with Docker

You can also explore Lesli locally by running the **Lesli Docker Demo**.



```shell

# Clone the Repository
git clone https://github.com/LesliTech/lesli-docker-demo.git

# Navigate into the folder
cd lesli-docker-demo

# Start the Demo Environment
docker compose up --build
```


<br/>

## Logging into Your Lesli Instance

Navigate to the Lesli demo website using your favorite web browser: [http://127.0.0.1:3000](http://127.0.0.1:3000)

The demo environment comes preloaded with default users, each with different roles and privileges. To explore the platform fully, use the Owner account:

**Username:** hello@lesli.tech <br>
**Password:** Test123!

<lesli-browser host="http://localhost:3000/" url="login">
    <img src="/images/engines/shield/screenshot-login.png">
</lesli-browser>

> The Lesli Docker demo and Rails demo template includes all official Lesli modules pre-installed, along with a set of sample data for testing and exploration.
