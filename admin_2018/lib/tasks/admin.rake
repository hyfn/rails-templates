namespace :admin do
  desc 'Create a new admin - rails admin:create[email,password]'
  task :create, [:email, :password] => :environment do |_, args|
    Admin.create!(email: args[:email], password: args[:password])
  end
end
