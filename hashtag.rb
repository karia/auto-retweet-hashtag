require 'twitter'

client = Twitter::REST::Client.new do |conf|
  conf.consumer_key = ENV['TWITTER_CONSUMER_KEY']
  conf.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
end

query = "#ミコのえほん"
search_count = 100

result = client.search(query, count: search_count, result_type: "recent")

result.take(search_count).each do |tw|
  #RTは除外
  next if tw.full_text.start_with?("RT @")
  puts "https://twitter.com/#{tw.user.screen_name}/status/#{tw.id}"
  puts tw.created_at.getlocal
  puts tw.full_text
end

