# Workflows para Engines.

Hasta el momento Github no proporciona una forma de poder reutilizar los workflows y actions entre 
repositorios y por esta razon que existe el repositorio: [https://github.com/leitfaden/github_actions/](https://github.com/leitfaden/github_actions/)

El repositorio de [github_actions](https://github.com/leitfaden/github_actions/) se guardan las actions y los workflows que se reutilizan. 

Hay dos tipos de workflows: 

1. Builder: Workflows para los builders
1. Module: Workflows para los engines

## Generar o Actualizar una Workflow desde una plantilla

Con la siguiente tarea se puede generar un workflow para un engine.

```bash
rake dev2:github:actions
```

Condiciones:
1. El repositorio github_actions tiene que estar en la carpeta engines del core
1. Los engines tiene que estar en la carpeta engines del core

Luego que se actualiza o se crean se tiene que dar commit y push.

## Workflow para test

El workflow plantilla es:

> workflows/module/rails_test_pull_request_master_production.yaml

Este workflow ejecuta los test de Rspec usando el core.

## Workflow para construir una gema

El workflow plantilla es:

> workflows/module/rails_gem_build_publish_merge_production
 
Esta plantilla contiene los siguientes pasos:
1. Genera los asset compilados para produccion
1. Elimina la carpeta vue
1. Genera un tag de version 
1. Hace un bum de la verison de la gema
1. Publica la gema en github packages.

> NOTA:  Para detalles tecnicos ir al repositorio github_actions