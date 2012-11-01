require 'dependor'

require_relative 'bogus/takes'
require_relative 'bogus/record_interactions'
require_relative 'bogus/rspec_extensions'

all_files = Dir[File.expand_path('../**/*.rb', __FILE__)]
all_files = all_files.reject{|f| f.include?('bogus/rspec') }.sort
all_files.each { |f| require f }

module Bogus
  extend PublicMethods
end
