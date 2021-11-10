# Declaración de Dependencias para un Engines Build

Las dependencias se tiene que declarar el archivo lesli.yml del engine de tipo build.

El key es "modules" y este contiene el nombre de la gema y como valor la version que es dependiente.

Ejemplos:

```yaml
modules:
    cloud_babel: "~> 0.0.0"
```


# Cambios en gemas para poder Publicarla

## Permisos para publicar

Para evitar publicaciones accidentales  a repositorio publicos de gemas (Rubygems) hay que restringir la publicación solo github de la organización.

Modificar el gemspec del engine:
> FILE: engine/engine.gemspec

```ruby
spec.metadata['allowed_push_host'] = 'https://rubygems.pkg.github.com/leitfaden'
```

## Agregar archivos de configuración de lesli

Agregar los archivos de configuración de lesli (lesli.yml, routes.rb) en el gemspec para que la gema conserve esos archivos.

Ejemplo: 
> FILE: [engine_name]/[engine_name].gemspec
```ruby
spec.files = Dir["{app,config,db,lib}/**/*", "license", "Rakefile", "readme.md", "lesli.yml", "routes.rb"]
```

## Assets

Para hacer que los asset estén disponible para la aplicación wrapper de rails (core) hay que agregar los assets a la configuración de rails.

> FILE: [engine_name]/lib/[engine_name]/engine.rb
```ruby
config.assets.precompile += %w( manifest.js )
```

Ejemplo:
> FILE: [engine_name]/lib/[engine_name]/engine.rb
```ruby
module DemoEngineDevops
  class Engine < ::Rails::Engine
    isolate_namespace DemoEngineDevops
    config.assets.precompile += %w( [engine_name]_manifest.js )
  end
end
```

> FILE: [engine_name]/app/assets/config/[engine_name]_manifest

```javascript
//= link_tree ../stylesheets/[engine_name] .css
//= link_tree ../javascripts/[engine_name] .js
//= link_tree ../images/[engine_name] .png
//= link_tree ../images/[engine_name] .jpg
//= link_tree ../images/[engine_name] .svg
```

## Migraciones

Hay que agregar el path de migraciones del engine en la configuracion de rails por medio del archivo engine.rb

> FILE: [engine_name]/lib/[engine_name]/engine.rb
```ruby
module DemoEngineDevops
  class Engine < ::Rails::Engine
    isolate_namespace DemoEngineDevops

    # add migrations
    initializer :append_migrations do |app|
      unless app.root.to_s.match root.to_s
        config.paths["db/migrate"].expanded.each do |expanded_path|
          app.config.paths["db/migrate"] << expanded_path
        end
      end
    end
  end
end
```

## Seeds

Todo engine tiene disponible el metodo root para conocer el path donde se encuentra instalado el engine.

No usar rutas absolutas para el path de la gema.

Ejemplos: Cargar seed segun enviroment.
```ruby
load "#{LesliCloud::Engine.root}/db/seed/#{Rails.env.downcase}.rb"
```
