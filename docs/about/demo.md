# Using Docker to run Lesli

<br />

Clone the LesliDemo repository from Github

```shell
# Inside your Rails root folder
git clone git@github.com:LesliTech/LesliDemo.git 
```

Run the Lesli image

```shell
docker compose up --build
```

Navigate to the Lesli demo website using your favorite web browser: [http://127.0.0.1:300](http://127.0.0.1:300)


### Logging into your new Lesli application
The seeders comes with default users with different roles and privileges, to see Lesli in action use the owner user:

__username:__ hello@lesli.tech 
__password:__ tardis2023$

<br />

::: info
The Lesli demo Docker image includes all the Lesli modules pre-installed and a collection of sample data.
:::
