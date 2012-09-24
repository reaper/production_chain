namespace :env do
  desc "reset your dev environment with default reference datas"
  task :reset => :environment do
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:seed'].invoke
  end

  desc "Rebuild with production data"
  task :rebuild_with_production_data => :environment do
    Rake::Task["env:rebuild_with_environment_data"].invoke("production")
  end

  desc "Rebuild with staging data"
  task :rebuild_with_staging_data => :environment do
    Rake::Task["env:rebuild_with_environment_data"].invoke("staging")
  end

  desc "Rebuild with environment data"
  task :rebuild_with_environment_data, [:remote_environment] => :environment do |t, args|
    local_env = Rails.env

    `rake db:drop db:create RAILS_ENV=#{local_env}`
    `cap #{args.remote_env} db:dump_and_restore RAILS_ENV=#{local_env}`
    `rake db:migrate RAILS_ENV=#{local_env}`
    `cap #{args.remote_env} assets:dump_and_restore RAILS_ENV=#{local_env}`
  end
end
