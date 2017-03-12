class EbkArticle

	def initialize(article)
		unless article.class==Nokogiri::XML::Element
			raise "Article needs to be instance of Nokogiri::XML::Element"
		end
		@article = article
		@title   = get_title
		@content = get_content
		@tags    = get_tags
	end

	attr_reader :article
	attr_reader :title
	attr_reader :content
	attr_reader :tags

	def inspect
		return [
			"#<EbkArticle",
			"title=#{@title.inspect}",
			"tags=#{@tags.inspect}",
			"content=#{@content.inspect}",
			"article=#{@article.inspect.split[0]+">"}",
			">"
		].join(" ")
	end

	private

	def get_title
		@article
		.css('h1[class="entry-title"]')
		.children[0]
		.children[0]
		.to_s
	end

	def get_tags
	
		raw = @article.attributes["class"].value.split
		raw.select!{|i|i[0,4]=="tag-"}
		raw.map! do |i|
			i[4,i.length]
				.split("-")
				.map{|ii|ii.gsub("ae","ä")}
				.map{|ii|ii.gsub("oe","ö")}
				.map{|ii|ii.gsub("ue","ü")}
				.map(&:capitalize)
				.join(" ")
		end
	
		return raw
	
	end

	def get_tags

		raw = @article.attributes["class"].value.split
			raw.select!{|i|i[0,4]=="tag-"}
			raw.map! do |i|
				i[4,i.length]
					.split("-")
					.map{|ii|ii.gsub("ae","ä")}
					.map{|ii|ii.gsub("oe","ö")}
					.map{|ii|ii.gsub("ue","ü")}
					.map(&:capitalize)
					.join(" ")
			end
	
		return raw

	end

	def get_content
		raw = @article.css('div[class="entry-content"]')
		child_map = raw.children.map do |child|
			case child.name
			when "p"
				
				child.children.map(&:to_s).map do |i|
					if i[0,3]=="<a "
						x = i.match(/<a[^>]*>([^<]*)<\/a>/)
						i.gsub!(x[0],x[1])
					end
					i.gsub(/<img[^>]*>/,"")
				end.join
			
			when "text"
				child.to_s.gsub(/\n/," ")
			
			end
		end
		
		child_map
		.select{|i|i.match(/[A-Za-z0-9]/)}
		.map{|i|i.gsub(/\.$/, ". ")}
		.join
		.chomp
		.gsub(/\s*$/,"")
	end

end