# frozen_string_literal: true

require_relative "null/version"
require_relative "null/mimic"
module ActiveRecord
  # Extend any ActiveRecord class with this module to add a null object.
  # Add it to your primary abstract class.
  #
  # @example
  #   class ApplicationRecord < ActiveRecord::Base
  #     primary_abstract_class
  #     extend ActiveRecord::Null
  #   end
  module Null
    # Define a Null class for the given class.
    #
    # @example
    #   class Business < ApplicationRecord
    #     Null do
    #       def name = "None"
    #     end
    #   end
    #
    #   Business.null # => #<Business::Null:0x0000000000000000>
    #   Business.null.name # => "None"
    #
    #   class User < ApplicationRecord
    #     Null([:name, :team_name] => "Unknown")
    #   end
    #
    #   User.null.name # => "Unknown"
    #   User.null.team_name # => "Unknown"
    #
    # @param inherit [Class] The class from which the Null object inherits attributes
    # @param assignments [Array] The attributes to assign to the null object
    def Null(inherit = self, assignments = {}, &)
      if inherit.is_a?(Hash)
        assignments = inherit
        inherit = self
      end
      null_class = Class.new do
        include ::ActiveRecord::Null::Mimic
        mimics inherit

        include Singleton

        class << self
          def method_missing(method, ...)
            mimic_model_class.respond_to?(method) ? mimic_model_class.send(method, ...) : super
          end

          def respond_to_missing?(method, include_private = false)
            mimic_model_class.respond_to?(method, include_private) || super
          end
        end
      end
      null_class.class_eval(&) if block_given?

      nil_assignments = inherit.attribute_names
      if assignments.any?
        assignments.each do |attributes, value|
          nil_assignments -= attributes
          null_class.define_attribute_methods(attributes, value:)
        end
      end
      null_class.define_attribute_methods(nil_assignments)
      inherit.const_set(:Null, null_class)

      inherit.define_singleton_method(:null) { null_class.instance }
    end

    def self.extended(base)
      base.define_method(:null?) { false }
    end
  end
end
