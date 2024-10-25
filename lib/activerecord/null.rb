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
    #   class Business
    #     Null do
    #       def name = "None"
    #     end
    #   end
    #
    #   Business.null # => #<Business::Null:0x0000000000000000>
    #
    def Null(inherit: self, &)
      null_class = Class.new do
        include ::ActiveRecord::Null::Mimic
        mimics inherit

        include Singleton
      end
      null_class.class_eval(&)
      null_class.define_attribute_methods(inherit.attribute_names)
      const_set(:Null, null_class)

      define_singleton_method(:null) { null_class.instance }
    end

    def self.extended(base)
      base.define_method(:null?) { false }
    end
  end
end
