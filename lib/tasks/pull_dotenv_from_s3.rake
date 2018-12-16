# frozen_string_literal: true

desc 'Pull .env file with environment variables'
task fetch_s3_dotenv: :environment do
  FetchDotenvFromS3.fetch_dotenv
end

class FetchDotenvFromS3
  def self.fetch_dotenv
    if system("aws s3 cp s3://#{ENV['CONFIG_URI']}/.env #{Rails.root}")
      puts 'Fetching .env from s3 seems to have worked out.'
    else
      puts 'There was an error fetching the .env file from s3.'
    end
  end
end
