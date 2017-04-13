#Nolan Roach and others
#
#This crawler v2.0 is going to index much more
#data so that we can do page rank and other features.

require 'fast-stemmer'
require 'yaml'

require_relative 'WebPage.rb'

class Crawler
	@@delayTime = 1 #for now it's one page every second
	@@pageDirectory = "pages/" #would probably be easier just to type this out but this is more descriptive
	#instance variables
	attr_reader :queue
	attr_reader :currentHTMLPage
	attr_reader :pageLimit
	attr_reader :documentIndex
	attr_reader :invertedIndex
	#attr_reader :
	
	#initializer
	def initialize(pageLimit = 20, seedHyperlink = "https://www.indiana.edu/")
		@pageLimit = pageLimit
		@documentIndex = Hash.new()
		@documentIndex.default = []
		@invertedIndex = Hash.new()
		@invertedIndex.default = []
        @currentHTMLPage = WebPage.new(seedHyperlink)
		@queue = Array.new
		#@queue.push(seedHyperlink)
    end
	
	#class functions
    def hello()
        puts "Hello!"
		puts "I am ready to crawl..."
    end
	
	def getPage(hyperlink, previousPage=NIL, previousPageRank=NIL)
		@currentHTMLPage = WebPage.new(hyperlink, previousPage, previousPageRank)
	end
	
	#the big daddy
	def crawlPages()
		#load the current indexes
		@documentIndex = Crawler.loadData("documentIndex.yml")
		@invertedIndex = Crawler.loadData("invertedIndex.yml")
		count = 0
		while @pageLimit != 0
			@documentIndex[@currentHTMLPage.address] = count.to_s + ".yml"
			#save the page
			savePage(count.to_s + ".yml")
			#get links, queue them
			#puts(@currentHTMLPage.to_s)
			@currentHTMLPage.links.each do |link|
				if @documentIndex.has_key?(link)
					#handle PageRank changes
					pageToUpdate = Crawler.loadCrawledPage(@documentIndex[link])
					rankVal = @currentHTMLPage.rank / @currentHTMLPage.links.size
					pageToUpdate.updateRank(rankVal)
					puts("Updated pageRank of: \t#{pageToUpdate.address}\tto\t#{pageToUpdate.rank}")
				else
					if not @queue.include?(link)
						@queue.push(link)
					end
				end
			end
			#merge page index data
			@currentHTMLPage.index.each do |string, word|
				if not @invertedIndex.has_key?(string)
					@invertedIndex[string] = Hash.new
				end
				#this line basically makes this program
				wordHash = @invertedIndex[string]
				wordHash[@currentHTMLPage.address] = [@currentHTMLPage.title, @currentHTMLPage.rank, (word.docFrequency / @currentHTMLPage.wordCount), word.docPositions]
			end
			#get next page
			puts("Indexed and saved: \t#{@currentHTMLPage.address}\tto\t#{count.to_s + ".yml"}")
			getPage(queue.shift())
			count += 1
			@pageLimit -= 1
		end
		saveData("documentIndex.yml", @documentIndex)
		saveData("invertedIndex.yml", @invertedIndex)
	end
	
	#using yaml encoding for objects
	#YAML::load(serialized_object)
	def savePage(fileName = "testPage.yml")
		#File.open("file.rb") if File::exists?( "file.rb" )
		file = File.new(@@pageDirectory + fileName, "w+")
		serializedPage = YAML::dump(@currentHTMLPage)
		file.puts(serializedPage)
		file.close
		#puts("saved page: #{fileName}")
	end
	
	#this method is really only needed in a few cases
	#for now its mainly used to add inbound links to a pager
	#so we can update its PageRank
	def self.loadCrawledPage(fileName = "testPage.yml")
		#File.open("file.rb") if File::exists?( "file.rb" )
		loadedPage = YAML.load_file(@@pageDirectory + fileName)
		return loadedPage
	end
	
	def saveData(fileName = "dataTest.yml", data)
		file = File.new(fileName, "w+")
		serializedData = YAML::dump(data)
		file.puts(serializedData)
		file.close
	end
	
	def self.loadData(fileName = "dataTest.yml")
		data = YAML.load_file(fileName)
		return data
	end
end
# END CRAWLER CLASS