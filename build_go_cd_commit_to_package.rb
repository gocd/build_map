#!/usr/bin/env ruby
require 'fileutils'
include FileUtils

$stdout.sync = true
$stderr.sync = true

unless(ENV['UPDATE_GOCD_BUILD_MAP'])
  puts "Not updating build_map repo as Environment variable UPDATE_GOCD_BUILD_MAP is not set, exiting.."
  exit(true)
end

cd __dir__ do
  entry = "#{ENV['GO_TO_REVISION_GOCD']}:#{ENV['GO_PIPELINE_COUNTER']}/#{ENV['GO_STAGE_COUNTER']}"
  File.open('commit_build_map', 'a') do |f|
    f.puts entry
  end

  sh 'git add .'
  sh "git commit -m 'Update map file - #{entry}' --author 'GoCD CI User <12554687+gocd-ci-user@users.noreply.github.com>'"
  sh %Q{git push "https://#{ENV['BUILD_MAP_USER']}:#{ENV['BUILD_MAP_PASSWORD']}@github.com/gocd/build_map" master}
  puts "Map file updated"
end
