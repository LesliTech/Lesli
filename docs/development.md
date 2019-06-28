<p align="center">
	<a href="https://lesli.cloud" target="_blank">
		<img width="90" alt="LesliCloud logo" src="https://cdn.lesli.tech/leslicloud/brand/leslicloud_isotipo-nomargin.png" />
	</a>
</p>

<h3 align="center">LesliCloud</h3>

---

#### Getting the code
```
git pull origin master
```

#### Rails ENV variables
```
bin/rails db:environment:set RAILS_ENV=development
```

#### Working with the database  
```
rails db:drop
rails db:create
rails db:migrate
rails db:seed
```  

#### Scaffolding
The scaffolding tool creates all the necessary files for an app resource, including:
- Migrations
- Models
- Controllers
- Views
- Tests

```
command structure
rails generate scaffold [namespace]/[object]

example:
rails generate scaffold students/personal_details

uploaders:
rails generate uploader core/attachments
```

#### Rails dev server
```
rails server
```

#### Reset database  
```bin/rails db:environment:set RAILS_ENV=development && rails db:drop && rails db:create && rails db:migrate && rails db:seed```  
