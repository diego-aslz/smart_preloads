module SmartIncludes
  module Adapters
    module ActiveRecordAdapter
      def smart_includes
        SmartIncludes::List.new(all)
      end
    end

    ActiveRecord::Base.extend ActiveRecordAdapter if defined?(ActiveRecord)
  end
end
