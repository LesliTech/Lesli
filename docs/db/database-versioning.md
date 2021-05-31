
# Database versioning
Every stable version of the platform should come with their own database structure; Lesli database version is completely different from Rails migration versioning.  

Every change (version) of the database should be in their own folder, the folder should be named with the name of the current working version of the system and the migration should be prefixed with the same version that we are currently working on.  

## Database versioning example
| version       |   migration name
|-              |- 
| version 1.0   |   00000003_create_test (actual)
| version 1.1   |   1100000003_update_test (agrego un campo nuevo)
| version 1.2   |   1200000003_update_test (agrego otro campo nuevo)
| version 2.0   |   1200000003_update_test (cambio de string a integer)
