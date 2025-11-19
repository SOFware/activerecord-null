# frozen_string_literal: true

require "test_helper"

# Test that Null classes can be defined without database access
class LazyLoadingTest < Minitest::Spec
  describe "Lazy attribute loading" do
    it "allows Null class definition without database access" do
      # Create a new model class with a fake table_exists? check
      table_available = false

      test_class = Class.new(ApplicationRecord) do
        def self.name
          "TestModel"
        end

        define_singleton_method(:table_exists?) do
          table_available
        end

        define_singleton_method(:attribute_names) do
          ["id", "name", "email"]
        end
      end

      # Extend with Null - this should NOT require database
      test_class.extend ActiveRecord::Null

      # Define the Null class - this should also NOT require database
      # This is the key fix - Null() doesn't call attribute_names
      assert_silent do
        test_class.Null([:name] => "Unknown")
      end

      # The Null class constant should exist
      assert test_class.const_defined?(:Null)

      # Now make table available
      table_available = true

      # When we call .null with table available, attributes get loaded
      null_instance = test_class.null
      assert_instance_of test_class::Null, null_instance
      assert_equal "Unknown", null_instance.name
      assert_nil null_instance.email
    end

    it "initializes attributes only once" do
      call_count = 0
      test_class = Class.new(ApplicationRecord) do
        def self.name
          "CountingModel"
        end

        define_singleton_method(:table_exists?) do
          true
        end

        define_singleton_method(:attribute_names) do
          call_count += 1
          ["id", "value"]
        end
      end

      test_class.extend ActiveRecord::Null
      test_class.Null

      # Calling .null multiple times should only initialize once
      assert_equal 0, call_count
      test_class.null
      assert_equal 1, call_count
      test_class.null
      assert_equal 1, call_count
      test_class.null
      assert_equal 1, call_count
    end

    it "handles missing database gracefully" do
      # Create a model that simulates a missing database
      test_class = Class.new(ApplicationRecord) do
        def self.name
          "MissingDbModel"
        end

        define_singleton_method(:table_exists?) do
          false
        end

        define_singleton_method(:attribute_names) do
          raise ActiveRecord::NoDatabaseError, "Database 'test' does not exist"
        end
      end

      test_class.extend ActiveRecord::Null

      # Should be able to define Null class without database
      assert_silent do
        test_class.Null([:name] => "Unknown")
      end

      # Accessing .null returns the instance (but no attributes are defined yet)
      null_instance = test_class.null
      assert_instance_of test_class::Null, null_instance

      # Without a table, no attributes work (not even custom ones)
      # This is fine - in CI, you wouldn't call .null before running migrations
      assert_raises(NoMethodError) { null_instance.name }
    end

    it "handles missing table gracefully" do
      # Create a model that simulates a missing table
      test_class = Class.new(ApplicationRecord) do
        def self.name
          "MissingTableModel"
        end

        define_singleton_method(:table_exists?) do
          false
        end

        define_singleton_method(:attribute_names) do
          raise ActiveRecord::StatementInvalid, "Table 'missing_table_models' doesn't exist"
        end
      end

      test_class.extend ActiveRecord::Null

      # Should be able to define Null class without table
      assert_silent do
        test_class.Null([:status] => "inactive")
      end

      # Accessing .null returns the instance
      null_instance = test_class.null
      assert_instance_of test_class::Null, null_instance

      # Without a table, attributes don't work
      assert_raises(NoMethodError) { null_instance.status }
    end
  end
end
