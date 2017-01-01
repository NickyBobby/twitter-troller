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

today = Date.today
two_days_ago = Date.today.prev_day.prev_day

options = {
  count: 200
}

tweets = client.user_timeline('stevekinney', options)

tweets.each do |tweet|
  tweet_date = Date.parse(tweet.created_at.to_s)
  if tweet_date < today && tweet_date > two_days_ago
    client.favorite(tweet)
    client.retweet(tweet) rescue 'already tweeted'
    if tweet.reply?
      reply_count += 1
    elsif tweet.retweet?
      retweet_count += 1
    else
      tweet_count += 1
    end
    puts tweet.text
  end
end

client.update("Done liking/retweeting Steve Kinney's tweets from yesterday: #{tweet_count} original tweets, #{reply_count} replies and #{retweet_count} retweets. #SubtlyTrollingSteve2017")
