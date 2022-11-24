
### Icons preprocessing 
Automatically generate an SVG sprite from a folder of SVG icons.

Execute at project root level
```bash
svgo -f ./app/assets/icons/lesli -o ./app/assets/icons/lesli
svgeez build --prefix="" --source ./app/assets/icons/lesli --destination ./app/views/layouts/partials/_application-lesli-icons.svg
mv ./app/views/layouts/partials/_application-lesli-icons.svg ./app/views/layouts/partials/_application-lesli-icons.html.erb
```
