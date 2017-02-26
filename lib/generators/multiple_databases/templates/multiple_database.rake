config_file = Rails.root.join('config', 'multiple_database.yml')
config =
  if File.exist?(config_file)
    YAML.load(ERB.new(File.new(config_file).read).result)
  else
    raise ArgumentError.new('Check...............')
  end

db_operations = { 
  drop: 'config/multiple_database.yml for the current RAILS_ENV',
  create: 'config/multiple_database.yml for the current RAILS_ENV',
  setup: 'Create the database, load the schema, and initialize with the seed data (use db:reset to also drop the database first)',
  migrate: 'Migrate the database (options: VERSION=x, VERBOSE=false)',
  rollback: 'Rolls the schema back to the previous version (steps w/ STEP=n)',
  version: 'Retrieves the current schema version number',
  seed: 'Load the seed data from xx/seeds.rb'
}

db_schema = {
  load: 'Load a schema.rb file into the database',
  dump: 'Create a xx/schema.rb file that is portable against any DB supported by AR'
}

if config.present?
  config['databases'].each do |db_name, _|
    task spec: ["#{db_name}:db:test:prepare"]
    namespace db_name.to_sym do
      namespace :db do |ns|
        db_operations.each do |ope_name, ope_desc|
          desc ope_desc.to_s
          task ope_name do
            Rake::Task["db:#{ope_name}"].invoke
          end
        end

        namespace :schema do
          db_schema.each do |sc, description|
            desc description
            task sc do
              Rake::Task["db:schema:#{sc}"].invoke
            end
          end
        end
     
        namespace :test do
          desc 'Runs all tests in test folder'
          task :prepare do
            Rake::Task['db:test:prepare'].invoke
          end
        end
     
        # append and prepend proper tasks to all the tasks defined here above
        ns.tasks.each do |task|
          task.enhance ["#{db_name}:set_custom_config"] do
            Rake::Task["#{db_name}:revert_to_original_config"].invoke
          end
        end
      end
    end
    desc 'set_custom_config'
    task :set_custom_config do
      # save current vars
      @original_config = {
        env_schema: ENV['SCHEMA'],
        config: Rails.application.config.dup
      }
   
      # set config variables for custom database
      ENV['SCHEMA'] = "#{db_name}/schema.rb"
      Rails.application.config.paths['db'] = ["#{db_name}"]
      Rails.application.config.paths['db/migrate'] = ["#{db_name}/migrate"]
      Rails.application.config.paths['db/seeds'] = ["#{db_name}/seeds.rb"]
      Rails.application.config.paths['config/database'] =
        ['config/database_stats.yml']
    end
    desc 'revert_to_original_config'
    task :revert_to_original_config do
      # reset config variables to original values
      ENV['SCHEMA'] = @original_config[:env_schema]
      Rails.application.config = @original_config[:config]
    end
  end
end
