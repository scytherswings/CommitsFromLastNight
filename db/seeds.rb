# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'faker'

unless Rails.env == 'production'
  account_names = Array.new
  repository_names = Array.new

  50.times { account_names << Faker::Internet.user_name }
  20.times { repository_names << Faker::App.name }
  5000.times do
    user = User.find_or_create_by!(account_name: account_names[rand(0..49)], avatar_uri: 'https://bitbucket.org/account/unknown/avatar/48/?ts=0')
    EmailAddress.find_or_create_by!(email: Faker::Internet::email, user: user)

    repository = Repository.find_or_create_by!(name: repository_names[rand(0..19)])

    message = Faker::Hacker.say_something_smart + ' ..Fuck! ' + (rand(0..1).times.collect { |_| Faker::Hacker.say_something_smart }).join(' ')
    sha = Faker::Crypto.sha1
    commit_time = Faker::Time.between(DateTime.now - 2.months, DateTime.now - 1.day) # https://github.com/stympy/faker/pull/675
    Commit.create!(message: message, sha: sha, utc_commit_time: commit_time, user: user, repository: repository)
  end
end