require 'forwardable'

module Bogus
  class ActiveRecordAccessors
    extend Takes
    extend Forwardable

    takes :klass, :instance_methods

    def_delegators :instance_methods, :remove, :define

    def all
      return [] unless klass < ActiveRecord::Base
      return missing_attributes
    end

    def get(name)
      Attribute.new(name)
    end

    private

    undef :instance_methods if defined? :instance_methods
    def instance_methods
      @instance_methods.call(klass)
    end

    def all_attributes
      klass.columns.map(&:name).map(&:to_sym)
    end

    def missing_attributes
      all_attributes - instance_methods.all
    end

    class Attribute < Struct.new(:name)
      def parameters
        []
      end
    end
  end
end
