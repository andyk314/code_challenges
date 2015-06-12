require 'twitter' #Twitter Gem to handle oauth authentication
require 'pry'

client = Twitter::Streaming::Client.new do |config|
  config.consumer_key        = "kJjHeYfEfyntSEWEMn7XOQ"
  config.consumer_secret     = "QblfGzMOBtHKUMi6wvicKNp8wwVP5OgT4T3MWtKV8"
  config.access_token        = "51576730-di772Znf0DVBE5vP1OHw5DbxhMRvuV18hOQ8Ts7vE"
  config.access_token_secret = "cSWi9gyJaaRZctgacnhOEirLsEg6vzwABAktF9RLKgWIH"
end

counts = Hash.new(0)
current_time = Time.now
time_limit = Time.now + 300 #get 5 minutes of tweets
client.sample do |object|
  break if current_time > time_limit
  if object.is_a?(Twitter::Tweet) && object.lang == "en"
    response = object.text
    words = response.downcase.tr(",.?!",'').split(' ')
    rejected_words = ['and', 'the', 'me', 'to', 'in', 'rt', 'i', 'my', 'when', 'just', 'it', 'a', 'that', 'for', 'this', 'is', 'our', 'over', 'go', 'not', 'one', 'for', 'you', 'we', 'was', 'at', 'your', 'up', 'of', 'be', 'are', 'have', 'like', 'will', 'so', 'but', 'but', 'with', 'they', 'can', 'all', 'still', 'if', 'on', 'no', 'how', '&amp', "i'm", 'an', 'who', 'from', 'am', "it's", 'u', 'do', 'by', '&amp;', 'ur', '-', "you're", "really", ]
    r_words = words.reject{|w| rejected_words.include?(w) || w.length < 6}
    r_words.each { |word| counts[word] +=1 }
    current_time = Time.now
  end
  counts
end

p counts.sort_by {|_key, value| value}.reverse.first(10)
