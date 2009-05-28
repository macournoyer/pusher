require "rake/clean"
require "spec/rake/spectask"

CLOBBER.include "client/pusher.js"

task :default => :spec

Spec::Rake::SpecTask.new do |t|
  t.spec_opts = %w(-fs -c)
  t.spec_files = FileList["spec/**/*_spec.rb"]
end

task :client do
  require "sprockets"
  secretary = Sprockets::Secretary.new(
    :load_path    => ["client/src"],
    :source_files => ["client/src/pusher.js"]
  )

  # Generate a Sprockets::Concatenation object from the source files
  concatenation = secretary.concatenation
  # Write the concatenation to disk
  concatenation.save_to("client/pusher.js")
end

