# frozen_string_literal: true

require 'rake/testtask'

# set default so travis can build properly
task default: :test

Rake::TestTask.new do |t|
  t.test_files = FileList['test/test_*.rb']
  t.warning = false
end
