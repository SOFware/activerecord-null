# frozen_string_literal: true

require "bundler/gem_tasks"
require "minitest/test_task"

Minitest::TestTask.create

task default: :test

require "reissue/gem"

Reissue::Task.create :reissue do |task|
  task.version_file = "lib/activerecord/null/version.rb"
  task.fragment = :git
end
