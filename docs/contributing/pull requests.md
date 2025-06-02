# Pull requests

### Pull requests are for humans
Remember to review other people's code just ike you would like to your code be reviewed.

**Be kind:** Any improvement or change you think can be made in the reviewing code, try to write a message (or review) with touch, care and empathy.

**Be clear:** Make it easy for the developer understand your feedback, avoid any workaround and write down only your comments/suggestions of the code you are reviewing.

**Be specific:** Write as many messages as needed and select directly the line of code where your suggestion starts. Try to avoid general feedback, not try to cover so much in a single sentence.

### Give clear suggestions and recommendations
Do not write that code needs to be fixed or can be improved without giving suggestions or recommendations on what to fix or how to fix it, also, a brief explanation is always welcome.


### Always assume good intent
Code may not be written how you would write it. Let’s say that more clearly: code is rarely written the same way by two different people. After all, code is a craft, not a task on an assembly line.

Tap into a sense of curiosity and appreciation while reviewing – curiosity to understand what the reviewer had in mind and gratitude for what the developer did or tried to do.


### Clarify the action and the level of importance. 
If you are making an optional suggestion, for example, a “nit” that isn't necessary before the code is approved for production, say so clearly. 

If you wonder why the person made a particular choice, but it doesn’t affect whether the code should make it to production, say so clearly. 

If you are confident that the code needs to be fixed before it is ready for production, say so clearly. 


### Don't forget that all feedback can include praise.
It is not necessary to say that the key benefit of doing code reviews is to make the code better and fix issues. 
But that's only half of it. On the flip side, code reviews present an excellent opportunity to thank you and appreciate your colleagues' work. 
If someone has written particularly elegant or maintainable code or has made a great decision about using a library, let them know!


## What to review 
The code review is always up to the point of view of the developer that is reviewing, and there are no specif or hard rules about what the developers have to check to aprove or deny a pull request.

Here are some suggestions about we can review: 

**Documentation:** license at the begining of every code file, brief description for every method.
**Use of correct responders:** like respond_with_successful or respond_with_pagination.
**Inherit from the correct CloudObjects:** ApplicationLesliResponder, ApplicationLesliRecord, etc.
**Use of the correct tools for an specific tasks:** Date2 for date parsing, etc.


## What a pull requests must include
- Complete set of tests for the controller, model or api that the pull requests is about.
- Clear and brief list of changes. (Use the description of the PR)


## Pull Request Structure
Before merging any commit into master, it is necessary a review from at least one developer other than the one who did the commit. The only exception to this rule are the compiled assets for production, which can be merged immediately and even commited and pushed directly into master. 

If there is at least one small change in the code, a pull request has to be made. 

More than one requirement can be included into a single pull request. However, these card *must* be related in a meaningful way; if they are not, two or more pull requests must be created. In order to ensure that every pull request contains all the information available of the changes, bug fixes and new features, the next structure has to be followed:

__Title:__

```
Title: "[add|remove|fix|improve|etc.]: Brief description of changes included in this pull request"
```

__Description:__ 

```
Changelog:

- Added x feature to y view
- Removed x button from z view
- Fixed n controller action to accept several params
- etc.
```

## Merge process 
Once the requirement is completed developers must check a few steps before send a pull request:

- Run linters and fix any warning or error.
- Run code static analysis tools, fix any issue related to your code :)
- Add documentation about changes or new code/files
- Execute the complete test suite 

When everything is ready developer can send a pull request using the Github web interface or the Git cli.
Github automatically checks for conflicts between branches, if there are no conflicts user can create the pull request and assign team members to review and authorize to merge the branch with master.
If github detects any merge conflict developer must work with a team member to fix conflics and complete the merge process.
