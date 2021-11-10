
# Lesli settings file

Lesli use a file to initialize the basic settings needed to start the app. We can customize this settings using dedicated instance lesli.yml file or dedicated file per server.  

### Location
```plaintext
    Lesli/
        app
        config
        engines/
            standard_engine
            builder_instance/
                lesli.yml   -> required
        lib
        public
        storage
        vendor
        lesli.yml           -> required
        lesli.server.yml    -> optional
```

### Core base settings
By default the app comes with a base settings file located at the root of the app.

### Instance settings
Every builder engine must include a lesli.yml settings file at the root of the engine folder.

### Server settings
You can include a file at the root of the app path to override the settings, this option is usefull to when we need to change some settings for an instalation or server, for example: if we have a test server we can change the default url for email using this special file. __IMPORTANT__: this file only works at the root of the rails app and is ignored in github, so you have to create the file if you want to use this feature.  

### NOTE: 
The core base settings include all the configurations available, but in the instance or server file you can include only the settings you want to change.
