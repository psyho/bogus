module Bogus
  class EnsuresAllInteractionsSatisfied
    extend Bogus::Takes

    takes :gets_shadow

    def ensure_satisfied!(objects)
      unsatisfied = unsatisfied_interactions(objects)
      return if unsatisfied.empty?

      calls = all_calls(objects)
      raise NotAllExpectationsSatisfied.create(unsatisfied, calls)
    end

    private

    def unsatisfied_interactions(objects)
      mapcat_shadows(objects) do |object, shadow|
        shadow.unsatisfied_interactions.map{|c| [object, c]}
      end
    end

    def all_calls(objects)
      mapcat_shadows(objects) do |object, shadow|
        shadow.calls.map{|c| [object, c]}
      end
    end

    def mapcat_shadows(objects, &block)
      mapped = objects.map do |object|
        shadow = gets_shadow.for(object)
        block.call(object, shadow)
      end

      mapped.reduce([], :concat)
    end
  end
end
