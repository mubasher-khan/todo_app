namespace :deploy do
  namespace :check do
    before :linked_files, :set_database_yml do
      on roles(:app), in: :sequence, wait: 10 do
        upload! 'config/database.yml', "#{shared_path}/config/database.yml"
        unless test("[ -f #{shared_path}/config/master.key ]")
          upload! 'config/master.key', "#{shared_path}/config/master.key"
        end
      end
    end
  end
end