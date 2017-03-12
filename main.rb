require 'nokogiri'
require 'net/http'
require 'timeout'
load 'ebk-article.rb'

get_page = lambda do 
	#Net::HTTP.get(URI("https://eigenbaukombinat.de"))
	File.read("page.html")
end

res = Nokogiri::HTML(get_page.call)
articles = res.css('article').to_a
x = EbkArticle.new(articles[0])
p x