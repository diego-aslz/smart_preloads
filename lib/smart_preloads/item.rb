module SmartPreloads
  class Item < SimpleDelegator
    def initialize(record, loader: nil)
      super(record)
      @loader = loader || Loader.new([record])
      _override_associations
    end

    def _override_associations
      __getobj__.class.reflections.each do |key, association|
        original = method(key)
        singleton_class.class_exec do
          body = nil
          if %i(has_many has_and_belongs_to_many).include?(association.macro)
            body = lambda do
              List.new(original.call, loader: @loader.nested(key.to_sym))
            end
          else
            body = lambda do
              @loader.load(key.to_sym)
              original.call
            end
          end
          define_method(key, &body)
        end
      end
    end
  end
end
