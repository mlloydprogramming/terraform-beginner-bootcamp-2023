# Terraform Beginner Bootcamp 2023 - Week 2

## Working with Ruby

### Bundler

Bundler is a package manager for Ruby.
It is the primary way to install ruby packages (known as gems).

#### Install Gems

You need to create a Gemfile and define your gems in that file.

```rb
# frozen_string_literal: true

source "https://rubygems.org"

gem 'sinatra'
gem 'rake'
gem 'pry'
gem 'puma'
gem 'activerecord'
```

Then you need to run the `bundle install` command

This will install the gems on the system globally (unlike nodejs which install packages in place in a folder called node_modules)

A Gemfile.lock will be created to lock down the gem versions used in this project.

#### Executing Ruby scripts in the context of bundler

We must use `bundle exec` to tell future ruby scripts to use the gems we installed. This is the way we set context.

#### Sinatra

Sinatra is a micro web-framework for ruby to build web-apps.

Its great for mock or development servers or for very simple projects.

You can createe a web-server in a single file.

[Sinatra](https://sinatrarb.com/)

## Terratowns Mock Server

### Running the web server

We can run the web server by executing the following commands:

```rb
bundle install
bundle exec ruby server.rb
```

All of the code for our server is stored in the `server.rb` file.

## CRUD

Terraform Provider Resources utilize CRUD.

Crud stands for Create, Read, Update, Delete

[CRUD](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete)