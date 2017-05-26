# smart_preloads

Avoid N + 1 queries without having to worry about it at all! It is also useful
when you do not have control over which associations are going to be used by
the view, like when you provide users customizable views with
[Liquid](https://github.com/chamnap/liquid-rails).

## Installation

You can use `gem install smart_preloads` to install it manually or use Bundler:

```ruby
gem 'smart_preloads'
```

## Usage

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

## How it Works

In order for it to work, `smart_preloads` has a custom list class
(`SmartPreloads::List`) and a custom item class for each item in a list
(`SmartPreloads::Item`).

The List class allows detecting when the collection
is really used (iterated) so only then the associations will be detected and
mokey patched in place. This is needed so whenever a call to an association
is made it will be loaded, even from calls from within the object itself.

The Item class monkey patches all association methods in the objects loaded
to intercept the calls. The monkey patch is **in place**, not global. Only
the objects in the `smart_preloads` collection will be monkey patched.

Note that when you call `Author.all.smart_preloads.first` you will **not**
have an instance of `Author`. Instead, you will have an instance of
`SmartPreloads::Item` that delegates calls to the original `Author` object.

## Contributing

* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a
future version unintentionally.
* Create a pull request.

## Copyright

Copyright (c) 2017 Diego Aguir Selzlein. See LICENSE.txt for further details.
