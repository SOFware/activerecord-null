# frozen_string_literal: true

require "test_helper"

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  extend ActiveRecord::Null
end

class Product < ApplicationRecord
  self.table_name = "businesses" # Reuse existing table

  Void([:name] => "Unknown Product") do
    def display_name
      "Product: #{name}"
    end
  end
end

class Comment < ApplicationRecord
  self.table_name = "posts" # Reuse existing table

  Void()
end

class ActiveRecord::TestVoid < Minitest::Spec
  describe "Void class definition" do
    it "creates Void constant on model" do
      assert Product.const_defined?(:Void)
    end

    it "Void class includes Mimic" do
      assert Product::Void.include?(ActiveRecord::Null::Mimic)
    end

    it "Void class does not include Singleton" do
      refute Product::Void.include?(Singleton)
    end

    it "defines .void method on model" do
      assert Product.respond_to?(:void)
    end

    it "Void can be defined without arguments" do
      assert Comment.const_defined?(:Void)
    end
  end

  describe ".void instantiation" do
    it "returns new instance each time" do
      void1 = Product.void
      void2 = Product.void

      assert_instance_of Product::Void, void1
      assert_instance_of Product::Void, void2
      refute_equal void1.object_id, void2.object_id
    end

    it "creates instance with no arguments" do
      void_obj = Product.void

      assert_instance_of Product::Void, void_obj
    end

    it "creates instance with empty hash" do
      void_obj = Product.void({})

      assert_instance_of Product::Void, void_obj
    end
  end

  describe "attribute handling" do
    it "returns default value from hash syntax" do
      void_obj = Product.void

      assert_equal "Unknown Product", void_obj.name
    end

    it "allows instance attributes to override defaults" do
      void_obj = Product.void(name: "Custom Product")

      assert_equal "Custom Product", void_obj.name
    end

    it "database attributes default to nil" do
      # Assuming businesses table doesn't have a 'price' column
      void_obj = Product.void

      # Name has a default, so it should return that
      assert_equal "Unknown Product", void_obj.name
    end

    it "supports multiple instances with different attributes" do
      void1 = Product.void(name: "Product A")
      void2 = Product.void(name: "Product B")

      assert_equal "Product A", void1.name
      assert_equal "Product B", void2.name
    end

    it "instance attributes don't affect class defaults" do
      void1 = Product.void(name: "Modified")
      void2 = Product.void

      assert_equal "Modified", void1.name
      assert_equal "Unknown Product", void2.name
    end
  end

  describe "custom methods from block" do
    it "block-defined methods are accessible" do
      void_obj = Product.void

      assert_respond_to void_obj, :display_name
    end

    it "block methods can access attributes" do
      void_obj = Product.void(name: "Special")

      assert_equal "Product: Special", void_obj.display_name
    end

    it "block methods work with defaults" do
      void_obj = Product.void

      assert_equal "Product: Unknown Product", void_obj.display_name
    end
  end

  describe "type checking" do
    it "is_a?(Model) returns true" do
      void_obj = Product.void

      assert void_obj.is_a?(Product)
    end

    it "is_a?(Model::Void) returns true" do
      void_obj = Product.void

      assert void_obj.is_a?(Product::Void)
    end

    it "null? returns true" do
      void_obj = Product.void

      assert void_obj.null?
    end

    it "persisted? returns false" do
      void_obj = Product.void

      refute void_obj.persisted?
    end

    it "new_record? returns false" do
      void_obj = Product.void

      refute void_obj.new_record?
    end

    it "destroyed? returns false" do
      void_obj = Product.void

      refute void_obj.destroyed?
    end
  end

  describe "callable attribute values" do
    it "supports callable defaults" do
      test_class = Class.new(ApplicationRecord) do
        def self.name
          "CallableTest"
        end

        self.table_name = "users"

        Void([:name] => -> { "Computed Name" })
      end

      void_obj = test_class.void

      assert_equal "Computed Name", void_obj.name
    end

    it "callable defaults can access instance context" do
      test_class = Class.new(ApplicationRecord) do
        def self.name
          "ContextTest"
        end

        self.table_name = "users"

        Void([:name] => -> { "Hello" })

        def greeting
          "Welcome"
        end
      end

      void_obj = test_class.void

      assert_equal "Hello", void_obj.name
    end
  end

  describe "integration with Null" do
    it "Null and Void can coexist on same model" do
      # Define both on a test class
      test_class = Class.new(ApplicationRecord) do
        def self.name
          "TestModel"
        end

        self.table_name = "users"

        Null([:name] => "Null Default")
        Void([:name] => "Void Default")
      end

      null_obj = test_class.null
      void_obj = test_class.void

      assert_equal "Null Default", null_obj.name
      assert_equal "Void Default", void_obj.name
      assert_equal null_obj.object_id, test_class.null.object_id # Singleton
      refute_equal void_obj.object_id, test_class.void.object_id # Not singleton
    end
  end

  describe "model integration" do
    it "respects table_name from parent model" do
      assert_equal Product.table_name, Product::Void.table_name
    end

    it "respects primary_key from parent model" do
      assert_equal "id", Product::Void.primary_key
    end

    it "has mimic_model_class reference" do
      void_obj = Product.void

      assert_equal Product, void_obj.mimic_model_class
    end
  end
end
