module Bogus
  class NotAllExpectationsSatisfied < StandardError
    def self.create(unsatisfied_interactions, calls)
      str = <<-EOF
      Some of the mocked interactions were not satisfied:

      <% unsatisfied_interactions.each do |o, i| %>
        - <%= render_interaction(o, i) %>
      <% end %>

      The following calls were recorded:

      <% calls.each do |o, i| %>
        - <%= render_interaction(o, i) %>
      <% end %>
      EOF
      str = str.gsub(/ {6}/, '')
      template = ERB.new(str, nil, "<>")
      new(template.result(binding))
    end

    def self.render_interaction(object, interaction)
      args = interaction.args.map(&:inspect).join(", ")
      "#{object.inspect}.#{interaction.method}(#{args})"
    end
  end
end
