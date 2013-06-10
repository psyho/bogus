module Bogus
  class AddsMissingColumnAccessors
    def add(klasses)
      klasses = ActiveRecord::Base.send(:descendants) if klasses.empty?
      klasses.each do |klass|
        define_accessors(klass)
      end
    end

    private

    def define_accessors(klass)
      missing_accessors(klass).each do |name|
        define_accessor(klass, name)
      end
    end

    def fields(klass)
      klass.columns.map(&:name).map(&:to_sym)
    end

    def missing_accessors(klass)
      fields(klass).reject do |name|
        klass.instance_methods.include?(name)
      end
    end

    def define_accessor(klass, name)
      klass.send(:define_method, name) do
        self[name]
      end
    end
  end
end
