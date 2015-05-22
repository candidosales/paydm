# Load DSL and Setup Up Stages
require 'capistrano/setup'

# Includes default deployment tasks
require 'capistrano/deploy'

require 'capistrano/bundler'
require 'capistrano/rails'
require 'capistrano/rails/collection'
require 'capistrano3/unicorn'

# If you are using rbenv add these lines:
 require 'capistrano/rbenv'

# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
Dir.glob('lib/capistrano/tasks/*.cap').each { |r| import r }
