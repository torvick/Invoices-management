# Invoices management (API)

##  Project setup
- Ruby version: 3.1.0
- PostgreSQL (at least version 9.3 installed)
- Configuration: You can use any container manager such as Docker, or setup directly in your local.

## Running
### 1. Download the dependencies
```bash
$ bundle install --path=vendor
```

### 2. Run pending migrations
```bash
$ bundle exec rails db:migrate
```

### 3. Populate the database with the seeds.rb file
```bash
$ bundle exec rails db:seed
```

### 3. Start the app
```bash
$ bundle exec rails server
```

### 4. When using the document import service you should use
```bash
$ rake jobs:work
```
#### run the tasks in the background

## Postman

## The services can be found in the following button

[![Run in Postman](https://run.pstmn.io/button.svg)](https://app.getpostman.com/run-collection/be0f4697c6fa98750d59?action=collection%2Fimport#?env%5BInvoices%5D=W3sia2V5IjoiZGV2IiwidmFsdWUiOiJsb2NhbGhvc3Q6MzAwMCIsImVuYWJsZWQiOnRydWUsInR5cGUiOiJkZWZhdWx0Iiwic2Vzc2lvblZhbHVlIjoibG9jYWxob3N0OjMwMDAiLCJzZXNzaW9uSW5kZXgiOjB9LHsia2V5IjoicHJvZCIsInZhbHVlIjoiaHR0cDovLzM1LjkzLjU0LjQ0OjMwMDAiLCJlbmFibGVkIjp0cnVlLCJ0eXBlIjoiZGVmYXVsdCIsInNlc3Npb25WYWx1ZSI6Imh0dHA6Ly8zNS45My41NC40NDozMDAwIiwic2Vzc2lvbkluZGV4IjoxfSx7ImtleSI6InRva2VuIiwidmFsdWUiOiIiLCJlbmFibGVkIjp0cnVlLCJ0eXBlIjoiYW55Iiwic2Vzc2lvblZhbHVlIjoiQmVhcmVyLi4uIiwic2Vzc2lvbkluZGV4IjoyfV0=)

## Bonus:
### you can test the application in this url
- base url: http://35.93.54.44:3000
