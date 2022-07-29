
Profile Routes
| HTTP method |                Route                                   |   Controller    | File Path                           | Test   |    Body     |
|     -       |                -                                       |         -       |  -                                  |   -    |   -         | 
|    GET      |    /administration/profile                             |   show          |  Profiles#show                      |    Y   |             |         
|    GET      |    /administration/profile/subscriptions               |   index         |  profile/subscriptions#index        |    N   |             |
|    GET      |    /administration/profile/subscriptions/options       |   options       |  profile/subscriptions#options      |    N   |             |  
|    PUT      |    /administration/profile/notifications/:id           |   update        |  profile/notifications#update       |    N   |             | 
|    PATCH    |    /administration/profile/notifications/:id           |   update        |  profile/notifications#update       |    N   |             | 
|    GET      |    /administration/profile/notifications               |   index         |  profile/notifications#index        |    N   |             |
|    GET      |    /administration/profile/webpushes                   |   create        |  profile/webpushes#create           |    N   |             | 
|    POST     |    	/administration/profile/webpushes                  |   index         |  profile/webpushes#index            |    N   |             |
