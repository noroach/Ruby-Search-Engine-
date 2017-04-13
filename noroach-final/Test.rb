require_relative 'WebPage.rb'
require_relative 'Word.rb'
require_relative 'Crawler.rb'

require 'mechanize'

#this is just a test module

def testCrawler()
	#since no start page is defined it defaults to IU
	c = Crawler.new(100, "https://en.wikipedia.org/wiki/Main_Page/")
	puts(c)
	c.hello()
	puts(c.currentHTMLPage.page.class)
	puts(c.currentHTMLPage.to_s)
	#c.savePage()
	#puts(c.currentHTMLPage.links)
	#puts(c.currentHTMLPage.lines)
	#puts(c.currentHTMLPage.rawText)
	#c.getPage("https://www.wikipedia.org/" , c.currentHTMLPage.address, (c.currentHTMLPage.rank / c.currentHTMLPage.links.size))
	#puts(c.currentHTMLPage.to_s)
	#puts(c.currentHTMLPage.index)
	#testLoad = Crawler.loadCrawledPage()
	puts(c.pageLimit.to_s)
	c.crawlPages()
end

def testGetLinks()
	agent = Mechanize.new
	#page = agent.get("https://www.wikipedia.org/")
	page = agent.get("https://www.indiana.edu/")
	page.links_with(:href => /^https?/).each do |link|
		puts (link.href)
	end
end

def testSave()
	file = File.new("test/" + "page1", "w+")
	#file = File.open(currentHTMLPage.address, "w+")
	file.puts("just some stuff")
	file.close
end

def testWebPage()
	p = WebPage.new("http://www.cnn.com/")
	puts(p)
end

def testWord()
	w = Word.new("running")
	puts(w)
end

def testHash()
	a = Hash.new
	a ["x"] = 1
	a ["y"] = 2
	a ["z"] = 3
	a ["a"] = Hash.new
	
	b = a
	
	a ["t"] = -1
	
	puts(b)
	
end

def load_stopwords_file(file = "stop.txt") 
    stop_words = Hash.new(0)
    file = File.open(file, "r")
    file.readlines.each do |word|
      stop_words[word.chomp] = 1
    end

    file.close
    write_data("stopWords", stop_words)
end

def write_data(filename, data)
  file = File.open(filename, "w+")
  file.puts(data)
  file.close
end

def testMech()
	mechanize = Mechanize.new

	page = mechanize.get('http://www.cnn.com')

	puts page.at('body').text.strip.split(/\W+/)
end

#load_stopwords_file()
#testGetLinks()
#testWord()
#testWebPage()
testCrawler()
#testHash()
#testSave()
#testMech()