require 'rails/generators'
module MultipleDatabases
  # Copying databases.yml to config folder
  class InstallGenerator < Rails::Generators::Base
    desc 'Copy databases.yml to config'
    source_root File.expand_path('../templates', __FILE__)

    def copy_config_file
      copy_file 'multiple_database.yml', 'config/multiple_database.yml'
    end
  end
end
