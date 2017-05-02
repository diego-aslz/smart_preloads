module SmartIncludes
  autoload :Item, 'smart_includes/item'
  autoload :List, 'smart_includes/list'
  autoload :Loader, 'smart_includes/loader'
end

require 'smart_includes/adapters/active_record_adapter'
