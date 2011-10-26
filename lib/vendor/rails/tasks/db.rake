namespace :db do
  namespace :test do
    task :prepare_with_kanban do
      BinFlip::BINS.each do |bin|
        ENV['RAILS_ENV'] = Rails.env = bin

        Rake::Task['db:drop'].execute
        Rake::Task['db:create'].execute
        Rake::Task['db:migrate'].execute
        Rake::Task['db:schema:dump'].execute
        Rake::Task['db:test:prepare_without_kanban'].execute
      end
    end
  end
end

alias_task('db:test:prepare_without_kanban', 'db:test:prepare')
alias_task('db:test:prepare', 'db:test:prepare_with_kanban')
