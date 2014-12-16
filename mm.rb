require 'optparse'
require 'ostruct'
require 'bundler/setup'

Bundler.require(:default)

options = OpenStruct.new

options.n = 20

OptionParser.new do |o|
  o.on('-n', '--number NUMBER', 'Specify the number of sentences to output.') do |n|
    n = n.to_i

    if n < 1
      n = 1
    end

    options.n = n
  end
end.parse!

feed_uri = 'http://mimihatesyou.com/home?format=RSS'

agent = Mechanize.new

raw_feed_xml = agent.get(feed_uri).body

feed = Feedjira::Feed.parse(raw_feed_xml)

markov = MarkyMarkov::TemporaryDictionary.new

markov.parse_string feed.entries.map { |entry| Sanitize.clean(entry.summary) }.join(' ')

puts markov.generate_n_sentences options.n
