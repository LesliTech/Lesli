<p align="center">
	<a href="#" target="_blank">
		<img alt="LesliCSS logo" width="200px" src="https://cdn.lesli.tech/leslidev/leslicss/brand/leslicss-imagotipo.svg" />
	</a>
</p>

<h3 align="center">SCSS Utilities for websites and web applications</h3>

<hr/>

Version 0.7.2  


#### Installation
--------
```console
npm install lesli-css --save
```


#### Structure
--------
```text
LesliCSS  
├── src/  
│    ├── base/  
│    │    ├── fonts.scss  
│    │    └── normalize.scss  
│    ├── functions/  
│    │    └── colors.scss  
│    ├── helpers/  
│    │    ├── columns.scss  
│    │    ├── flex.scss  
│    │    └── grid.scss  
│    └── mixins/  
│        ├── breakpoints.scss  
│        └── scrollbar.scss  
└── vendor  
```


#### Usage
--------
```scss

@import "lesli-css";

// Get color from the standard pallete
.test {
	color: lesli-css-get-color(blue);
	color: lesli-css-get-color(blue, 100);
	color: lesli-css-get-color(blue, 300);
	color: lesli-css-get-color(blue, 500); // default
	color: lesli-css-get-color(blue, 700);
	color: lesli-css-get-color(blue, 900);
}

```


### License  
------
Software developed in [Guatemala](http://visitguatemala.com/) distributed under the *General Public License v 3.0* you can read the full license [here](http://www.gnu.org/licenses/gpl-3.0.html)

<p align="center">
	<a href="https://www.lesli.tech" target="_blank">
		<img alt="LesliTech logo" width="150" src="https://cdn.lesli.tech/leslitech/brand/leslitech-logo.svg" />
	</a>
</p>
