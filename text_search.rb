# The program should start by asking the user for a file name. When that 
# filename is given, the program should open it and build a trie from that file.
# Then the user should be able to input strings to search for 
# (this should be on a loop that only ends if the user types :q).
# 1.Typing :q should quit the program
# 2.If the string that is entered is not in the text (therefore not in the trie)
#   print a statement saying that the string is not found.
# 3.If the string is a full word in the text, the program should print out all
#   locations at which the string occurs.
#   The location should indicate line number and word number.
# 4.If the string is a prefix for any words in the text,the program should print
#   out all the strings that occur in the text that start with that prefix
#   (recommended doing a DFS of that subtree.)
# 5.If the input string is both a full word and a prefix, you just need to print#   the locations of the full word.

class TrieNode
    attr_accessor :children, :is_EOW, :locations
  
    def initialize
      @children = {} # hash table: Key-> Char, Val -> TrieNode
      @is_EOW = false
      @locations = []
    end
  end
  
  class Trie
    def initialize
      @root = TrieNode.new
    end
  
    def insert(word, location)
      node = @root # Traverse from the root of trie
      word.each_char do |char|
        if !node.children.key?(char)
          node.children[char] = TrieNode.new
        end
        # moves the traversal to the next level 
        node = node.children[char]
      end
  
      node.is_EOW = true
      node.locations.append(location)
    end
  
    def search(word)
      node = find_node(word)
      if node && node.is_EOW
        return node
      else
        # word not found 
        return nil
      end
    end
  
    # start with return a list of words that start with "prefix"
    # unless condition
    #   code to be executed if the condition is false 
    # else 
    #   code to be executed if the condition is true 
  
    def starts_with(prefix)
      node = find_node(prefix)
      unless node
        return nil
      else
        words = []
        dfs(node, prefix, words)
      end
  
      return words
    end
  
    private
  
    def find_node(word)
      node = @root
      word.each_char do |char|
        unless node.children.key?(char)
          return nil
        else
          node = node.children[char]
        end
      end
      return node
    end
  
    def dfs(node, prefix, words)
      if (node.is_EOW)
        words.append(prefix)
      end
      node.children.each { |char, child| dfs(child, prefix + char, words) }
    end
  
  end
  
  def build_trie_from_file(filename)
    trie = Trie.new #build a trie
  
    File.open(filename, 'r') do |file|
      file.each_with_index do |line, line_num|
        line.split.each_with_index do |word, word_num|
          trie.insert(word, [line_num, word_num])
        end
      end
    end
  
    return trie
  end
  
  
  def search_trie(trie)
    loop do
      puts 'Type a string to search for. '
      input = gets.chomp
      break if input == ':q'
  
      # Find the word
      if (node = trie.search(input))
        node.locations.each { |location| puts "(#{location[0]}, #{location[1]})"}
      # The word could be a prefix
      elsif (words = trie.starts_with(input))
        puts words.join("\n")
      # word not found 
      else
        puts 'Not found.'
      end
  
    end
  end
  
  puts "Type the name of your file."
  filename = gets.chomp
  
  trie = build_trie_from_file(filename)
  
  search_trie(trie)