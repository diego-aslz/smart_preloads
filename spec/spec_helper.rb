if ENV['COVERAGE']
  require 'simplecov'

  module SimpleCov::Configuration
    def clean_filters
      @filters = []
    end
  end

  SimpleCov.configure do
    clean_filters
    load_profile 'test_frameworks'
  end

  SimpleCov.start do
    add_filter '/.rvm/'
    add_filter '/.rbenv/'
  end
end
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'active_record'
require 'smart_preloads'
require 'rspec'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.before(:suite) do
    ActiveRecord::Base.establish_connection adapter: 'sqlite3',
                                            database: ':memory:'
    ActiveRecord::Schema.define do
      create_table :books do |t|
        t.string :name
        t.integer :category_id
        t.integer :author_id
      end

      create_table :authors do |t|
        t.string :name
      end

      create_table :categories do |t|
        t.string :name
      end

      create_table :tags do |t|
        t.string :name
        t.belongs_to :taggable, polymorphic: true
      end
    end
  end

  config.around(:each) do |example|
    ActiveRecord::Base.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end
end
