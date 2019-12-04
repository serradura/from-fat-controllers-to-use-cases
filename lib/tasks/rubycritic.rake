require "rubycritic/rake_task"

RubyCritic::RakeTask.new do |task|
  # Glob pattern to match source files. Defaults to FileList['.'].
  task.paths   = FileList['app/**/*.rb']
end
