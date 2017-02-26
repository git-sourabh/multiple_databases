require 'multiple_database'
require 'rails'

module MultipleDatabases
  # Gem rake available to Rails app where gem will use
  class Railtie < Rails::Railtie
    railtie_name :multiple_database

    rake_tasks do
      load 'tasks/multiple_database.rake'
    end
  end  
end
