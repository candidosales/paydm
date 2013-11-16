def kill_postgres_connections_sql(database)
  <<-EOS
  SELECT
    pg_terminate_backend(pid)
  FROM
    pg_stat_activity
  WHERE pid <> pg_backend_pid() AND datname = '#{database}';
  EOS
end


def drop_database(config)
  case config['adapter']
  when /mysql/
    ActiveRecord::Base.establish_connection(config)
    ActiveRecord::Base.connection.drop_database config['database']
  when /^sqlite/
    require 'pathname'
    path = Pathname.new(config['database'])
    file = path.absolute? ? path.to_s : File.join(Rails.root, path)
    FileUtils.rm(file)
  when 'postgresql'
    ActiveRecord::Base.establish_connection(config.merge('database' =>'postgres','schema_search_path' => 'public'))
    ActiveRecord::Base.connection.execute(kill_postgres_connections_sql(config['database']))
    ActiveRecord::Base.connection.drop_database(config['database'])
  end
end