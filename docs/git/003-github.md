# Github management & settings

Para poder descargar las gemas que estan en el repositorio privado de github packages se tiene que:

1) Generar un token personal de github
2) Configurar las credenciales de bundle para que pueda descargar de github packages.


## Generar un token personal de github

En la pagina de github ir a:

1) Configuración de la cuenta personal
2) Developer settings
3) Seleccionar: Personal access tokens
4) Click: Generate new token
5) Dar permisos solamente de lectura (read:packges)

## Configurar bundle para descargar gemas de Github Packages

Una vez generado el token personal con permisos de lectura para leer paquetes en github se tiene que ejecutar el comando:

```bash
bundle config https://rubygems.pkg.github.com/leitfaden TOKEN
```
