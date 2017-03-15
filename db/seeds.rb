# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])

require 'importers/filter'

filter_files = Dir.glob('.resources/filter_categories/*.yml')

filter_files.each do |file|
  Importers::Filter.new.create_filterset_from_file(file)
end

#
# def generate_random_interjection
#   ['..damn..', '..fuck!', '..well that makes me sad.', '..how disappointing.', '...yes!', '...oh no..', '..whooppee!',
#    '...holy shit!', 'gee willikers, Batman!',
#    "...why do people use python anyway? There's no way it could be as fun as Ruby!"].sample
# end
#
# def generate_random_message
#   #   Mayor.create(name: 'Emanuel', city: cities.first)
#   message = []
#   message << Faker::Hacker.say_something_smart
#   message << (rand(0..1).times.collect { |_| generate_random_interjection }).join('')
#   message << (rand(0..1).times.collect { |_| Faker::Hacker.say_something_smart }).join('')
#   message.join(' ').strip
# end
#
# if Rails.env == 'test'
#   require 'faker'
#   account_names = Array.new
#   repository_names = Array.new
#
#   50.times { account_names << Faker::Internet.user_name }
#   20.times { repository_names << Faker::App.name }
#   5000.times do
#     user = User.find_or_create_by(account_name: account_names[rand(0..49)], avatar_uri: 'https://bitbucket.org/account/unknown/avatar/96/?ts=0')
#     EmailAddress.create(email: Faker::Internet::email, user: user)
#
#     repository = Repository.find_or_create_by(name: repository_names[rand(0..19)])
#
#     message = generate_random_message
#     sha = Faker::Crypto.sha1
#     commit_time = Faker::Time.between(DateTime.now - 2.months, DateTime.now, :between)
#     commit = Commit.create!(message: message, sha: sha, utc_commit_time: commit_time, user: user, repository: repository)
#     ExecuteFilters.perform_async(commit.id)
#   end
# end

