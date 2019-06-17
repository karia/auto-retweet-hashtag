require 'twitter'

client = Twitter::REST::Client.new do |conf|
  conf.consumer_key = ENV['TWITTER_CONSUMER_KEY']
  conf.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
end

query = "#ミコのえほん"
search_count = 100
done_list_file = "/var/tmp/tmp_tw.txt"

result_tw = client.search(query, count: search_count, result_type: "recent")

# RT済IDを読み込む
done_id = File.open(done_list_file).readlines

result_tw.take(search_count).each do |tw|
  #RTは除外
  next if tw.full_text.start_with?("RT @")
  #新着以外は除外
  next if done_id.include?(tw.id)

  # TODO: ここでRTする
  done_id.push(tw.id)

  puts "https://twitter.com/#{tw.user.screen_name}/status/#{tw.id}"
  puts tw.created_at.getlocal
  puts tw.full_text
end

# RT済IDを保存
File.open(done_list_file, "w") do |f|
  done_id.each do |id|
    f.puts(id)
  end
end

