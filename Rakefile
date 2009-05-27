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