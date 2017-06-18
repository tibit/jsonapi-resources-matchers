module JSONAPI
  module Resources
    module Matchers
      class HaveAttribute

        attr_accessor :name, :resource, :matcher

        def initialize(name, matcher)
          self.name = name
          self.matcher = matcher
          self.matcher = RSpec::Matchers::BuiltIn::Eq.new(matcher) if matcher && ! defined?(matcher.matches?)
        end

        def matches?(resource)
          self.resource = resource

          CheckSerialization.(self.resource)

          resource_class = resource.class

          serialized_hash = JSONAPI::ResourceSerializer.new(resource_class).
            serialize_to_hash(resource).with_indifferent_access
          expected_key = JSONAPI.configuration.key_formatter.format(name.to_s)
          attributes = serialized_hash["data"]["attributes"]

          return false if attributes.nil?
          return false unless attributes.has_key?(expected_key)
          @attribute_found= true
          return matcher.nil? || matcher === attributes[expected_key]
        end

        def failure_message
          resource_name = resource.class.name.demodulize
          %Q(#{matcher&.failure_message} for #{resource_name} attribute #{name}) if @attribute_found
          %Q(expected #{resource_name} to have attribute #{name}) unless @attribute_found
        end

        def description
          "have attribute #{name}"
        end

      end
    end
  end
end
