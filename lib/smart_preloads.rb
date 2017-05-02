module SmartPreloads
  autoload :Item, 'smart_preloads/item'
  autoload :List, 'smart_preloads/list'
  autoload :Loader, 'smart_preloads/loader'
end

require 'smart_preloads/adapters/active_record_adapter'
