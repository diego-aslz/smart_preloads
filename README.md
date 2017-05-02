# smart_preloads

Avoid N + 1 queries without having to worry about it at all! It is also useful
when you do not have control over which associations are going to be used by
the view, like when you provide users customizable views with
[Liquid](https://github.com/chamnap/liquid-rails).

## How it Works

You have to call `smart_preloads` at the end of your association. This will
generate a smart list of items that will load associations **if and when**
they are needed.

```ruby
@authors = Author.all.smart_preloads

@authors.each do |author|
  puts author.name
end
#=> SELECT "authors".* FROM "authors"

@authors.each do |author|
  author.books.each do |book|
    puts "#{author.name} authored #{book.name}"
  end
end
#=> SELECT "books".* FROM "books" WHERE "books"."author_id" IN (1, 2)
```

Note that when `books` is called for the first record, that association will be
loaded for all records at once.  This works for nested associations too:

```ruby
@authors.each do |author|
  author.books.each do |book|
    puts "#{author.name} authored #{book.name} (#{book.category.name})"
  end
end
#=> SELECT "categories".* FROM "categories" WHERE "categories"."id" IN (1, 2)
```

## Installation

You can use `gem install smart_preloads` to install it manually or use Bundler:

```ruby
gem 'smart_preloads'
```

## Contributing

* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a
future version unintentionally.
* Create a pull request.

## Copyright

Copyright (c) 2017 Diego Aguir Selzlein. See LICENSE.txt for further details.
