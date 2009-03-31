require 'core_extensions'
require 'flex_stuff'
require 'log_parser'
require 'web_analytics'
require 'flash_chart'
require 'page_layout'
require 'tracker_extensions'

module ActiveRecord
  module NamedScope
    class Scope
      attr_writer :proxy_options
      
    end
  end
end