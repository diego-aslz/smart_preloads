module SmartIncludes
  module Adapters
    module ActiveRecordAdapter
      def smart_includes
        # TODO
      end
    end

    ActiveRecord::Base.extend ActiveRecordAdapter if defined?(ActiveRecord)
  end
end
