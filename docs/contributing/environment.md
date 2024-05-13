# Development environment


### Editor
We recommend using [Visual Studio Code](https://code.visualstudio.com/). It is a free and open source editor that is available for all platforms. You can add some extensions to it to make it more useful for you.


### Ruby
Lesli uses [Ruby](https://www.ruby-lang.org/) as its primary programming language. The backend is written in Ruby with [Ruby on Rails](https://rubyonrails.org/) as its framework. **Lesli use the ruby version 3.1.2.**


#### Installation
Ruby is available for all platforms. If you need more details for the installation you can following the instructions [here](https://www.ruby-lang.org/en/documentation/quickstart/).  

To install Ruby, you have a couple of options. You can install [Ruby from the official website](https://www.ruby-lang.org/en/). If you choose to install it from there, you will have only one version of ruby and this can be a problem if you want to use multiple versions of ruby in different projects.  


#### Version Managers (recommended)
If you choose to install it with a version manager, you will have multiple versions of ruby, this is a good option if you use multiple versions of ruby in different projects. 

In the Ruby community, there are two popular managers responsible for installing and maintaining multiple Ruby versions [rvm](https://rvm.io/) (recommended) and [rbenv](https://rbenv.io/).  


__RVM pros over Rbenv:__

* RVM is easier to install than Rbenv.
* RVM has more features than Rbenv.
* RVM includes a built-in Ruby installation mechanism while Rbenv does not.


__Rbenv pros over RVM__:

* Rbenv is lightweight, RVM is heavier.
* Rbenv is more developer-friendly than RVM.
* Rbenv has a dedicated plugin for Ruby installation mechanism, RVM has it built-in.

After you install ruby you need to install rails and bundler. You can use the following commands in your terminal:

Install rails and bundler

```shell
gem install rails bundler
```


### Node.js
Node.js is a JavaScript runtime built on Chrome's V8 JavaScript engine. It is used for running JavaScript in the server side. Lesli uses node to run webpack, vue and other javascript libraries for the frontend. **To work with Lesli you can use the LTS version of Node.**

__Installation:__
Node.js is available for all platforms. If you need more details for the installation of specific version you can following the instructions [here](https://nodejs.org/en/).

__Version Manager (recommended):__
Node Version Manager (nvm) is a tool that allows the user to switch between different versions of Nodejs, helping to reduce overhead when reproducing production bugs in development environments. [The default installation](https://github.com/nvm-sh/nvm) is only supported on macOS and Linux environments. Windows users can follow the instructions [here](https://content.breatheco.de/es/how-to/nvm-install-windows).
For more information about nvm, you can go to this [link](https://github.com/nvm-sh/nvm).

Then you need to install yarn. You can use the following command in your 

terminal:

```shell
npm install -g yarn
```


### Postgresql
Lesli uses [Postgresql](https://www.postgresql.org/) as its database engine. It is a free and open source database that is available for all platforms. You can install postgresql on your computer and then you can use it to create a database for Lesli. The following links provide more information about the installation of postgresql.
    - [Install PostgreSQL on Windows](https://www.postgresqltutorial.com/postgresql-getting-started/install-postgresql/)
    - [Install PostgreSQL on macOS](https://www.postgresqltutorial.com/postgresql-getting-started/install-postgresql-macos/)
    - [Install PostgreSQL on Linux](https://www.postgresqltutorial.com/postgresql-getting-started/install-postgresql-linux/)


### Git
Git is a version control system that is used to track changes in files. It is used to manage the codebase of Lesli.


### Github
Github is a web-based Git repository hosting service that is used to store the codebase of Lesli. For download the codebase you need to clone the repository with ssh or with https. If you want to use ssh you need to create a ssh keys.


### Install engines
To install engines you need to clone the repository inside the engines folder. 
