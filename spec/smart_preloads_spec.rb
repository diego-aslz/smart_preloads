require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class Category < ActiveRecord::Base
  has_many :books
end

class Author < ActiveRecord::Base
  has_many :books
end

class Book < ActiveRecord::Base
  belongs_to :author
  belongs_to :category
  has_many :tags, as: :taggable
end

class Tag < ActiveRecord::Base
  belongs_to :taggable, polymorphic: true
end

describe 'SmartPreloads' do
  it 'smartly loads has_many associations' do
    Book.create!(name: 'Rework')
    Book.create!(name: 'Lean Startup')

    list = Book.all.smart_preloads.to_a

    expect(list.size).to eq(2)
    expect(list.first.association(:tags)).to_not be_loaded

    list.first.tags

    expect(list.first.association(:tags)).to_not be_loaded

    list.first.tags.first # forcing it to be loaded in the first item

    expect(list.first.association(:tags)).to be_loaded
    expect(list.last.association(:tags)).to  be_loaded
  end

  it 'smartly loads belongs_to associations' do
    Book.create!(name: 'Rework')
    Book.create!(name: 'Lean Startup')

    list = Book.all.smart_preloads.to_a

    expect(list.size).to eq(2)
    expect(list.first.association(:author)).to_not be_loaded

    list.first.author # forcing it to be loaded in the first item

    expect(list.first.association(:author)).to be_loaded
    expect(list.last.association(:author)).to  be_loaded
  end

  it 'smartly loads nested associations' do
    a1 = Author.create!(name: 'John')
    a2 = Author.create!(name: 'Robb')
    c1 = Category.create!(name: 'Humor')
    c2 = Category.create!(name: 'Horror')
    Book.create!(name: 'Rework', author_id: a1.id, category_id: c1.id)
    Book.create!(name: 'Lean Startup', author_id: a2.id, category_id: c2.id)

    list = Author.all.smart_preloads.to_a

    expect(list.size).to eq(2)
    expect(list.first.association(:books)).to_not be_loaded

    list.first.books.first # forcing it to be loaded in the first item

    expect(list.first.association(:books)).to be_loaded
    expect(list.last.association(:books)).to  be_loaded
    expect(list.first.books.first.association(:category)).to_not be_loaded
    expect(list.last.books.first.association(:category)).to_not  be_loaded

    list.first.books.first.category # forcing nested association to be loaded

    expect(list.first.books.first.association(:category)).to be_loaded
    expect(list.last.books.first.association(:category)).to  be_loaded
  end

  it 'supports concatenation' do
    Book.create!(name: 'Rework')
    Book.create!(name: 'Lean Startup')
    Author.create!(books: [Book.first])
    Author.create!(books: [Book.last])

    list = Book.all.smart_preloads + Author.all.smart_preloads

    list[2].books.to_a
    expect(list[3].association(:books)).to be_loaded

    list.first.author
    expect(list[1].association(:author)).to be_loaded
  end
end
