namespace :db do
  namespace :populate do
    desc "Create populate data with client sites"
    task create: :create_client_sites

    desc "Add client sites populate data"
    task create_client_sites: :read_environment do
      puts 'Client Site population (Dummy and 9 clients more)'

      start = Time.now

      # Create dummy site
      aid = Actor.find_by_slug('demo').id

      s = Site::Client.create! name: 'Dummy',
                               url: 'http://localhost:3000',
                               callback_url: 'http://localhost:3000/users/auth/socialstream/callback',
                               author_id: aid
      
      s.update_attributes! secret: "f9974ce87c455544f61cc960b58cf833eb039875ef27029449408857879a1e87283c86558e46fa431d37a3c5590ba92612c51dfd0872ccff35cbecf3910eaa02"

      9.times do
        domain = Forgery::Internet.domain_name 
        Site::Client.create! name: Forgery::Name.full_name,
                             url: "https://#{ domain }",
                             callback_url: "https://#{ domain }/callback",
                             author: User.all[rand(User.all.size)]
      end

      puts "   -> #{ (Time.now - start).round(4) }s"
    end
  end
end
