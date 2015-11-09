# REST API for Notes management

### Features
* CRUD operations
* Search by title/content/labels

### TO DO
* Unit tests
* Authentication tokens
* Caching - maybe sinatra_cache
* Paging for queries > N results
* Front end - Restful.js + React

### Install
Install gems
```
bundle install
```
Adjust config.json to your environment then
```
ruby api.rb
```

### Usage
* Get top 1000
http://localhost:4567/api/notes/

* Get by ID
http://localhost:4567/api/notes/15

* Search /may not work for some cases :D/
http://localhost:4567/api/search?title=rutrum&content=congue&label=easy

* POST / Create /
http://localhost:4567/api/notes/

fields => {
    title: "Sample Title",
    content: "My First Note",
    label: "cool, great"
}

* PUT
http://localhost:4567/api/notes/15

fields => {
    title: "Sample Title",
    content: "My First Note",
    label: "cool, great"
}

* DELETE note
http://localhost:4567/api/notes/15

* DELETE label
http://localhost:4567/api/labels/15
