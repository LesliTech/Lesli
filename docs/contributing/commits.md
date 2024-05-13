# Commits
The commit is used to confirm a set of changes and make them permanent in the repository, before committing the following points must be fulfilled: 

1. Download the latest changes from github 
2. Solve integration errors (merge between commits) if needed
3. Run tests 

Each commit has a specific structure in which information regarding work item, project, etc. is included. In addition to including a clear and precise description but also brief of the change that is being confirmed.

Every commit must meet the *Conventional Commits* standard


## Conventional Commits

The [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) specification is a lightweight convention on top of commit messages. It provides an easy set of rules for creating an explicit commit history; which makes it easier to write automated tools on top of. This convention dovetails with SemVer, by describing the features, fixes, and breaking changes made in commit messages.

The commit message should be structured as follows:

```
[type][optional scope]: [description]

[optional body]

[optional footer(s)]

git commit -m "type: trello/000 Brief description of changes included in this commits"
```

An example of such a message: 

````
fix: ABC-123: Caught Promise exception

We did not catch the promise exception thrown by the API call
and therefore we could not show the error message to the user
````

The commit type [type] can take one of these value:

- **fix**: A bug fix
- **feat**: A new feature
- **docs**: Documentation only changes
- **perf**: A code change that improves performance
- **test**: Adding missing tests or correcting existing tests
- **build**: Changes that affect the build system or external dependencies (example scopes: gulp, broccoli, npm)
- **style**: Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
- **ci**: Changes to our CI configuration files and scripts (example scopes: Travis, Circle, BrowserStack, SauceLabs)
- **refactor**: A code change that neither fixes a bug nor adds a feature
- **upgrade**: Changes a dependency version number (npm, gem, modules, etc)
- **assets**: Changes due a asset compilation process
- **release**: New version release process
- **BREAKING CHANGE:** a breaking API change
