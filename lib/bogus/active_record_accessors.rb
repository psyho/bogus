require 'forwardable'

module Bogus
  class ActiveRecordAccessors
    extend Takes
    extend Forwardable

    takes :klass, :instance_methods

    def_delegators :instance_methods, :remove, :define

    def all
      return [] unless klass < ActiveRecord::Base
      klass.columns.map(&:name)
    end

    def get(name)
      Attribute.new(name)
    end

    private

    def instance_methods
      @instance_methods.call(klass)
    end

    class Attribute < Struct.new(:name)
      def parameters
        []
      end
    end
  end
end
