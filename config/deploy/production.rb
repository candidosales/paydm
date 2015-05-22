set :stage, :production

set :deploy_to, '~/apps/paydm'

set :branch, 'master'

set :rails_env, 'production'

# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary
# server in each group is considered to be the first
# unless any hosts have the primary property set.
role :app, %w{deploy@45.79.0.161}
role :web, %w{deploy@45.79.0.161}
role :db,  %w{deploy@45.79.0.161}
