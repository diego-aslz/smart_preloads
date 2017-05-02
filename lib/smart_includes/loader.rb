module SmartIncludes
  class Loader
    attr_reader :collection

    def initialize(collection, nested_associations = nil)
      @collection = collection
      @nested_associations = nested_associations
    end

    def load_default
      load(nil)
    end

    def load(association)
      association = nest(association)
      return unless association
      ActiveRecord::Associations::Preloader.new.preload(@collection, association)
    end

    def nested(nested_associations)
      self.class.new(@collection, Array(@nested_associations) +
                                  Array(nested_associations))
    end

    def nest(association)
      return association unless @nested_associations
      result = association
      Array(@nested_associations).reverse.each do |parent|
        if result
          result = { parent => result }
        else
          result = parent
        end
      end
      result
    end
  end
end
