 ## Find Routes
```
1. To find a Route start the server and go to non-valid Route like http://localhost:3000/endpoints_list or run rails routes in terminal
2. You will be redirected to a page with the whole list of valid routes
3. This page will give you information like
```
| short description | HTTP method | Path  | Controller#Action |
| - | - | - | - |

 ## Write Test
```
1. Go to main_root/app/controllers folder and locate the controller file path (tip: use Controller#Action as a reference of where Controller is), Controller is the file name and Action is the method used inside the Controller file.
2. Go to main_root/spec/test/requests folder, must create a folder for each controller and create a file for every action you will test, using the next filename reference "action_rspec.rb"
```

                                                           
