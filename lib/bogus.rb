require 'dependor'

require_relative 'bogus/takes'
require_relative 'bogus/record_interactions'
require_relative 'bogus/proxies_method_calls'
require_relative 'bogus/rspec_extensions'
require_relative 'bogus/rspec_adapter'

all_files = Dir[File.expand_path('../**/*.rb', __FILE__)]
all_files = all_files.reject{|f| f.include?('bogus/rspec') }.sort
all_files.each { |f| require f }

module Bogus
  extend PublicMethods
end
