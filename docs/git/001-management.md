# Git management
Currently the version control system Git is used to versioning software projects.

## Git branching
To avoid conflicts between requirements developers must create a git branch to code the current requirement they are working on.  

In this case a Trello card, lesli ticket or github issue is equal to a requirement, developers can push all the needed commits to complete the feature required to their current working branch. 

A requirement can be: a new functionality, bug fixes and improvements.

### Branching system
**Features**: Every requirement must be developed on his own branch.
**Version**: Contains a set of requirements planned to be released within a specific version.
**Master**: Main development branch, all features branches send PR to this branch. This branch has the latest features.
**Test**: Branch for testing and QA (this branch is a previous step for production), only version and/or master can send PR to this branch.
**Production**: Stable branch for production environment, only the test branch can send PR to this branch.
**Hotfix**: Branch forked from production created to fix only on bugs or important changes that needs to be fixed urgently for production.

## Maintenance branches
As a good practice we keep a branch with the source code for every major and minor version for all our gem-like engines, including builder engines and the core itself.

Every repository should contain dedicated branches for every released version, for example: cloud_babel v1.0.0 belongs to the branch version-1.0.0; The goal of this approach is to continue supporting older versions of our software. providing an easy way to access to the source code of the different implementations of The Lesli Platform core, engines and builders.

This branch must be created manually right before a Git tag is created for #major or #minor version.

## Commits
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

<type>[optional scope]: <description>

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

The commit type <type> can take one of these value:

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

### Version commits
To upgrade the version in github we have to include a commit with an special message, indicating if major or minor version needs to be upgraded. By default patch version is upgraded.

## Pull Request Structure

Before merging any commit into master, it is necessary a review from at least one developer other than the one who did the commit. The only exception to this rule are the compiled assets for production, which can be merged immediately and even commited and pushed directly into master. 

If there is at least one small change in the code, a pull request has to be made. 

More than one requirement can be included into a single pull request. However, these card *must* be related in a meaningful way; if they are not, two or more pull requests must be created. In order to ensure that every pull request contains all the information available of the changes, bug fixes and new features, the next structure has to be followed:

Title:

```
Title: "[add|remove|fix|improve|etc.] trello/[####-####-####] Brief description of changes included in this pull request"
```

Description:

```
Changelog:

- Added x feature to y view
- Removed x button from z view
- Fixed n controller action to accept several params
- etc.
```

## Merge process 
Once the requirement is completed developers must check a few steps before send a pull request:

- Run linters and fix any warning or error
- Add documentation about changes or new code/files
- Execute the complete test suite 

When everything is ready developer can send a pull request using the Github web interface.
Github automatically checks for conflicts between branches, if there are no conflicts user can create the pull request and assign team members to review and authorize to merge the branch with master.
If github detects any merge conflict developer must work with a team member to fix conflics and complete the merge process.
