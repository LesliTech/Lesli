<p align="center">
	<img width="200" alt="LesliCloud logo" src="https://cdn.lesli.tech//lesli/brand/lesli-logo.svg" />
</p>

<h2 align="center">Vue plugins: MSG</h2>


### Description
Vue global message constructor. It displays a message as an alert above the content on the page.

<hr>


### Initialize
This plugin initializes automatically when the app is loaded and is included in every standard vue app.
It can be accessed from js like **this.msg** and from html like **msg**.

Example of accessing it:
```html
<script>

export default {
    methods: {
        doSomething(success) {
            // Do something then alert
            if (success) {
                this.msg.info('Hello!') // This is the way to use it on js
                this.msg.success('You do it!')
            } else {
                this.msg.error('Something crashed and do not worked')
            }
        }
    }
}
</script>
<template>
    <section class="application-component">
        <component-header title="Example Vue">
            <div class="buttons">

                <!-- This is the way to use it from html -->
                <b-button size="is-primary" @click="msg.info(`I am clickable`)" >
                    <span>Show info message</span>
                </b-button>

                <b-button size="is-primary" @click="msg.error(`Do not click me`)" >
                    <span>Show error message</span>
                </b-button>

                <b-button size="is-primary" @click="msg.success(`Click me`)" >
                    <span>Show success message</span>
                </b-button>

            </div>
        </component-header>
    </section>
</template>
```


<hr>


### List of available methods

**info**
* params:
    * **String** message: Some message you want to display.
* returns: [**Null**]
* description: This method will render a message as a **blue** alert above the content on the page.
* example:
```js
this.msg.info('Hello World')
```


**error**
* params:
    * **String** message: Some error or danger message you want to display.
* returns: [**Null**]
* description: This method will render a message as a **red** alert above the content on the page.
* example:
```js
this.msg.error('Something do not work')
```


**success**
* params:
    * **String** message: Some success message you want to display.
* returns: [**Null**]
* description: This method will render a message as a **green** alert above the content on the page.
* example:
```js
this.msg.success('Everything cool!')
```

<hr>
