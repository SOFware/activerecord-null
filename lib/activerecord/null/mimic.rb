# frozen_string_literal: true

require "active_support/concern"

module ActiveRecord
  module Null
    module Mimic
      extend ActiveSupport::Concern

      included do
        def self.mimics(mimic_model_class)
          @mimic_model_class = mimic_model_class
        end

        def self.mimic_model_class = @mimic_model_class

        def self.table_name = @mimic_model_class.to_s.tableize

        def self.primary_key = @mimic_model_class.primary_key

        def self.define_attribute_methods(attribute_names, value: nil)
          attribute_names.each do |attribute_name|
            unless method_defined?(attribute_name)
              if value.is_a?(Proc)
                define_method(attribute_name, &value)
              else
                define_method(attribute_name) { value }
              end
            end
          end
        end
      end

      def mimic_model_class = self.class.mimic_model_class

      attr_reader :id

      def [](*)
      end

      def is_a?(klass)
        if klass == mimic_model_class
          true
        else
          super
        end
      end

      def null? = true

      def destroyed? = false

      def new_record? = false

      def persisted? = false

      def has_query_constraints? = false

      def method_missing(method, ...)
        reflections = mimic_model_class.reflect_on_all_associations
        if (reflection = reflections.find { |r| r.name == method })
          case reflection.macro
          when :has_many
            define_memoized_association(method, reflection.klass.none)
          when :has_one, :belongs_to
            define_memoized_association(method, reflection.klass.null)
          else
            super
          end
        else
          super
        end
      end

      def respond_to_missing?(method, include_private = false)
        mimic_model_class.reflect_on_all_associations.map(&:name).include?(method) || super
      end

      private

      def define_memoized_association(method, value)
        self.class.define_method(method) do
          if instance_variable_defined?(:"@#{method}")
            instance_variable_get(:"@#{method}")
          else
            instance_variable_set(:"@#{method}", value)
          end
        end
        value
      end
    end
  end
end
