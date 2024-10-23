# frozen_string_literal: true

require "test_helper"

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  extend ActiveRecord::Null
end

class Business < ApplicationRecord
  Null do
    def name = "None"
  end
end

class Post < ApplicationRecord
  belongs_to :user
end

class User < ApplicationRecord
  belongs_to :business
  has_many :posts

  Null do
    def name = "None"
  end
end

class ActiveRecord::TestNull < Minitest::Spec
  describe ".null" do
    it "returns a null object" do
      expect(User.null).must_be_instance_of User::Null
    end
  end

  describe "Null" do
    it "is not persisted" do
      expect(User.null.persisted?).must_equal false
    end

    it "is not a new record" do
      expect(User.null.new_record?).must_equal false
    end

    it "is not destroyed" do
      expect(User.null.destroyed?).must_equal false
    end

    it "has a nil id" do
      expect(User.null.id).must_be_nil
    end

    it "is a User" do
      expect(User.null.is_a?(User)).must_equal true
    end

    it "is a User::Null" do
      expect(User.null.is_a?(User::Null)).must_equal true
    end

    it "has a mimic model class" do
      expect(User.null.mimic_model_class).must_equal User
    end

    it "responds to associations" do
      expect(User.null.respond_to?(:business)).must_equal true
    end

    it "has the mimic model class's table name" do
      expect(User::Null.table_name).must_equal "users"
    end

    it "has the mimic model class's primary key" do
      expect(User::Null.primary_key).must_equal "id"
    end

    it "has a null belongs_to association" do
      expect(User.null.business).must_be_instance_of Business::Null
    end

    it "has an empty relation for has_many association" do
      expect(User.null.posts).must_be_kind_of ActiveRecord::Relation
      expect(User.null.posts.to_a).must_equal []
    end
  end
end
