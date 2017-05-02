module SmartPreloads
  module Adapters
    module ActiveRecordAdapter
      def smart_preloads
        SmartPreloads::List.new(all)
      end
    end

    ActiveRecord::Base.extend ActiveRecordAdapter if defined?(ActiveRecord)
  end
end
