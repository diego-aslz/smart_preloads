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

describe 'SmartIncludes' do
  it 'works' do
    # TODO
  end
end
