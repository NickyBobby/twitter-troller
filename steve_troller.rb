require 'twitter'
require_relative 'twitter_keys.rb'

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = CONSUMER_KEY
  config.consumer_secret     = CONSUMER_SECRET
  config.access_token        = ACCESS_TOKEN
  config.access_token_secret = ACCESS_TOKEN_SECRET
end

retweet_count = 0
reply_count   = 0
tweet_count   = 0

options = {
  count: 200
}

tweets = client.user_timeline('stevekinney', options)

tweets.each do |tweet|
  if Date.today > Date.parse(tweet.created_at.to_s) && Date.today.prev_day.prev_day < Date.parse(tweet.created_at.to_s)
    client.retweet(tweet) rescue
    client.favorite(tweet) rescue
    puts tweet.text
    if tweet.reply?
      reply_count += 1
    elsif tweet.retweet?
      retweet_count += 1
    else
      tweet_count += 1
    end
  end
end

client.update("Done liking/retweeting Steve Kinney's tweets from yesterday: #{tweet_count} original tweets, #{reply_count} replies and #{retweet_count} retweets. #SubtlyTrollingSteve2017")
