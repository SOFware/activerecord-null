# frozen_string_literal: true

require "simplecov" if ENV["CI"]

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "activerecord/null"

require "active_record"
ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
load "test/support/schema.rb"

require "minitest/autorun"
