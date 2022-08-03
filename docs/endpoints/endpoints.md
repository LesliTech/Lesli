
Profile Routes
| HTTP method |                Route                                   |   Action        | File Path                           | Test   |    Body     |
|     -       |                -                                       |         -       |  -                                  |   -    |   -         | 
|    GET      |    /administration/profile                             |   show          |  Profiles#show                      |    Y   |             |         
|    GET      |    /administration/profile/subscriptions               |   index         |  profile/subscriptions#index        |    N   |             |
|    GET      |    /administration/profile/subscriptions/options       |   options       |  profile/subscriptions#options      |    Y   |             |  
|    PUT      |    /administration/profile/notifications/:id           |   update        |  profile/notifications#update       |    N   |             | 
|    PATCH    |    /administration/profile/notifications/:id           |   update        |  profile/notifications#update       |    N   |             | 
|    GET      |    /administration/profile/notifications               |   index         |  profile/notifications#index        |    N   |             |
|    POST     |    /administration/profile/webpushes                   |   create        |  profile/webpushes#create           |    Y   |             | 
|    GET      |    /administration/profile/webpushes                   |   index         |  profile/webpushes#index            |    Y   |             |
