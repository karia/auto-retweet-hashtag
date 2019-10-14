require 'twitter'

def idCheck(id,arr)
  arr.each do |i|
    return true if i.to_s.chomp == id.to_s
  end
  return false
end

client = Twitter::REST::Client.new do |conf|
  conf.consumer_key = ENV['TWITTER_CONSUMER_KEY']
  conf.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
  conf.access_token = ENV['TWITTER_ACCESS_TOKEN']
  conf.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
end

query = "#ミコのえほん -RT"
search_count = 100
done_list_file = "/var/tmp/tmp_tw.txt"

result_tw = client.search(query, count: search_count, result_type: "recent")

# RT済IDを読み込む
done_id = File.open(done_list_file).readlines

result_tw.take(search_count).each do |tw|
  # 新着ID以外は除外
  if idCheck(tw.id,done_id)
    #puts "[skip] https://twitter.com/#{tw.user.screen_name}/status/#{tw.id}"
    next
  end

  # RTリストに追加
  done_id.push(tw.id)

  # RTはRTせずに終了
  if tw.full_text.start_with?("RT @")
    puts "[RT] https://twitter.com/#{tw.user.screen_name}/status/#{tw.id}"
    next
  end

  # RTする
  client.retweet(tw.id)

  # RTしたツツイのログ取り
  puts "[NEW] https://twitter.com/#{tw.user.screen_name}/status/#{tw.id}"
  puts tw.full_text
  puts tw.created_at.getlocal
end

# RT済IDを保存
File.open(done_list_file, "w") do |f|
  done_id.uniq.each do |id|
    f.puts(id)
  end
end

puts "wrote file"

