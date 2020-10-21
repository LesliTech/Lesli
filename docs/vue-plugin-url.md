<p align="center">
	<img width="200" alt="LesliCloud logo" src="https://cdn.lesli.tech//lesli/brand/lesli-logo.svg" />
</p>

<h2 align="center">Vue plugins: URL</h2>

```js
let test = this.url
.api("administration/users")
.query({ status: "all" })
.exclude({ role: "kop,callcenter,guest" })
.pagination({ page: 1 })
```
