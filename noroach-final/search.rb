require 'yaml'

def loadData(fileName = "dataTest.yml")
	data = YAML.load_file(fileName)
	return data
end

def read_data(file_name)
	file = File.open(file_name,"r")
	object = eval(file.gets)
	file.close()
	return object
end
	
stopWords = read_data("stopWords")
documentIndex = loadData("documentIndex.yml")
invertedIndex = loadData("invertedIndex.yml")

# check that the user gave us correct command line parameters
abort "Command line should have at least 2 parameters." if ARGV.size<2

#mode = ARGV[0]
keyword_list = ARGV[0..ARGV.size]

#The invertedIndex looks like this...
#invertedIndex[keyWord] --> {address --> [pageRank, pageTitle, wordFrequency, [list of lines it appears on]]}

#The documentIndex looks like this...
#documentIndex[address] --> "1.yml"