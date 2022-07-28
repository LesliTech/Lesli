
Profile Routes
| HTTP method |                Route                                   |   Controller    | File Path                           | Test   |    Body     |
|     -       |                -                                       |         -       |  -                                  |   -    |   -         | 
|    GET      |    /administration/profile                             |   show          |  Profiles#show                      |        |             |         
|    GET      |    /administration/profile/subscriptions               |   index         |  profile/subscriptions#index        |        |             |
|    GET      |    /administration/profile/subscriptions/options       |   options       |  profile/subscriptions#options      |        |             |  
|    PUT      |    /administration/profile/notifications/:id           |   update        |  profile/notifications#update       |        |             | 
|    PATCH    |    /administration/profile/notifications/:id           |   update        |  profile/notifications#update       |        |             | 
|    GET      |    /administration/profile/notifications               |   index         |  profile/notifications#index        |        |             |
|    GET      |    /administration/profile/webpushes                   |   create        |  profile/webpushes#create           |        |             | 
|    POST     |    	/administration/profile/webpushes                  |   index         |  profile/webpushes#index            |        |             |
