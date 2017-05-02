module SmartPreloads
  class List
    include Enumerable

    def initialize(collection, loader: nil)
      @collection = collection
      @loader = loader || Loader.new(@collection)
    end

    def each
      loaded_collection.each do |resource|
        yield Item.new(resource, loader: @loader)
      end
    end

    def ==(other)
      to_a == other
    end

    def size
      to_a.size
    end

    protected

    def loaded_collection
      @loaded_collection ||= fetch_loaded_collection
    end

    def fetch_loaded_collection
      preload_defaults
      @collection
    end

    def preload_defaults
      @loader.load_default
    end
  end
end
