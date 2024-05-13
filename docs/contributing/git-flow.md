# Git management
Lesli uses git and github to build versions of all software products.

## Git branching
To avoid conflicts between requirements developers must create a git branch to code the current requirement they are working on.  

In this case a Trello card, Github issue, Lesli or any other id is equal to a requirement, developers can push all the needed commits to complete the feature required to their current working branch. 

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

This branch must be created manually just before a Git tag is created for #major or #minor version.
