require 'byebug'
require 'yaml'
require 'rails/generators'

module MultipleDatabases
  # Setup required strucuture
  class SetupDatabasesGenerator < Rails::Generators::Base
    desc 'Create individual forlder for each database and create corresponding'\
         ' migration generators.'
    source_root File.expand_path('../templates', __FILE__)

    def copy_folder_and_generator
      config_file = Rails.root.join('config', 'multiple_database.yml')
      config =
        if File.exist?(config_file)
          YAML.load(ERB.new(File.new(config_file).read).result)
        else
          raise ArgumentError.new('File not found')
        end

      config['databases'].each_key do |db_name|
        directory 'database_folder', db_name
        directory 'database_folder/migrate', "#{db_name}/migrate"
        directory 'generators', 'lib/generators'
        amend_class_name_and_folder_name(db_name)
      end
    end

    private

    def amend_class_name_and_folder_name(class_name)
      class_content =
"require 'rails/generators/active_record/migration/migration_generator'
class #{class_name.camelcase}Generator < ActiveRecord::Generators::MigrationGenerator
  source_root File
    .join(File
          .dirname(
            ActiveRecord::Generators::MigrationGenerator
              .instance_method(:create_migration_file)
              .source_location.first
          ), 'templates')

  def create_migration_file
    set_local_assigns!
    validate_file_name!
    migration_template @migration_template, %{#{class_name}/migrate/"+'#{file_name}'+".rb}
  end
end"
      File.open("lib/generators/#{class_name}_generator.rb", 'w') do |file|
        file.write(class_content)
      end
    end
  end
end
