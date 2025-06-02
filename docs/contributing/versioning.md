# Software Release
Every release of the platform should contain an unique version number, this number is calculated by an automatic action in github. Developers only need to carefully analyze to properly upgrade major, minor or patch version.

## Semantic Versioning 2.0.0
Following the semantic versioning spec helps other developers who depend on your code understand the extent of changes in a given version, and adjust their own code if necessary.

| Code status   | Stage         | Rule              | Example 
|-              |-              |-                  |-
| First release | New product   | Start with 1.0.0  | 1.0.0
| Backward compatible bug fixes | Patch release     | Increment the third digit | 1.0.1
| Backward compatible new features | Minor release  | Increment the middle digit and reset last digit to zero | 1.1.0
| Changes that break backward compatibility | Major release | Increment the first digit and reset middle and last digits to zero | 2.0.0

### Version number example
v1.0.0 
v1.1.0
v1.1.2

### Version number structure
To calculate a new version jut increase the number in the section required. 

|number     |description    |
|---        |---            |
| _v1_      | general platform version |
| _00_      | database changes  |
| _00_      | any other requirment (rails, vue, minor changes/small bug fiexes) | 

### Build number example
This build timestamp is created automatically during the compilation process executed by the github actions. 
210730.1825 
210731.1255 
210731.2208 

### Create a new version
All the new version for Core, Builders and Modules are created automatically through github actions, all you need to do es send a PR to the production branch from master or test and github will execute the necessary actions to test, compile, tag and versioning the software.  

If minor version upgrade is necessary, the last commit must include the tag "#minor"
If major version upgrade is necessary, the last commit must include the tag "#major"

You can modify the README.md file of the engine, the reflect the current version and ad the #minor text to the commit 

## Changelog
Today there is no automatic way to generate a changelong based on github commits/pull requests, so changelong must be created manually adding a friendly and general (but undestandable) description of changes released with the version.

This changelong must be part of the release email notification.
