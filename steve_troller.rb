require 'twitter'
require_relative 'twitter_keys.rb'
require 'pry'

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = CONSUMER_KEY
  config.consumer_secret     = CONSUMER_SECRET
  config.access_token        = ACCESS_TOKEN
  config.access_token_secret = ACCESS_TOKEN_SECRET
end


# steve = client.user('stevekinney')

options = {
  count: 200
}

tweets = client.user_timeline('stevekinney', options)

tweets.each do |tweet|
  if Date.today > Date.parse(tweet.created_at.to_s) && Date.today.prev_day.prev_day < Date.parse(tweet.created_at.to_s)
    client.retweet(tweet)
    puts tweet.text

  end
end
