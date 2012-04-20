class PlateSolver
    attr_accessor :input_list

	#Constructor
    def initialize( input_list )
		# Preserve original input list
		@input_list = input_list.map!{|w| w.downcase}
		puts "Input: " + @sorted_list.inspect

		# Sort input words so that words with matching 
		# start/end characters go to the front of the list.
		# This gives these words priority over others
		# when building the final output.
		@sorted_list = @input_list.sort{ |l,r| 
			#true if left word has matching first and last letters
			l_match = l[0] == l[l.length-1]
			#true if right word has matching first and last letters
			r_match = r[0] == r[r.length-1]
			
			if ( l_match && !r_match )
				-1
			elsif !l_match && r_match
				1
			else
				0
			end
		}

		build_maps
    end


	# Initialize maps to track start and end letter counts.
	# For each letter in the alphabet, store an integer count
	# of how many words in the word list start or end with that letter.
    def build_maps
		@start_map = {}
		@end_map = {}
		[*"a".."z"].each{ |l|
			@start_map[ l ] = 0
			@end_map[ l ] = 0
		}
		
		@sorted_list.each {|word|
			first_letter = word[0]
			last_letter = word[word.length-1]

			@start_map[ first_letter ] += 1
			@end_map[ last_letter ] += 1
		}
    end

	# Return solution array of input
	# Returns empty array [] if no solution
    def solve
		# Attempt to find a mismatch in start/end
		# letters in the maps.  This signifies first
		# and last words of the solution
		diff_list = []
		@start_map.each {|k,v|
			r = @end_map[k]
			diff = r-v
			puts "#{k} => #{v} | #{r} diff #{diff}"
			
			# If values in map don't match, remember this
			if diff != 0
				diff_list << diff
			end
		}

		# Ensure the matchings satisfy the properties of
		# and solvable puzzle.  If there are 
		puts diff_list
		if diff_list.size == 0
			# This means there are cycles (multiple
			# choices for the first word).
		elsif diff_list.size == 2
			# Ensure there is exactly one starting
			# word and exactly one ending word
			return [] if !diff_list.include?( 1 )
			return [] if !diff_list.include?( -1 )
		else
			# This signifies an unsolvable puzzle
			puts "Not Solvable"
			return []
		end

		# The characteristics of this word list look
		# good so far. Let's now try to enumerate the
		# solution array
		return enumerate_solution
    end

	# Output method for debug purposes
    def print_table
		@start_map.each {|k,v|
			r = @end_map[k]
			diff = r-v
			puts "#{k} => #{v} | #{r} diff #{diff}"
		}
    end

	
    def enumerate_solution
		@solution = []
		loop do 
			word = get_next_word
			if word == nil
				break
			else
				@solution << word
			end
		end

		if @solution.size < @input_list.size
			# More than one string of words would
			# be necessary for a valid solution
			puts "Not Solvable"
			return []
		else
			# Solution found!
			return @solution
		end
    end

    def get_next_word
		letter = nil
		@start_map.each {|k,v|
			r = @end_map[k]
			diff = v-r
			if diff > 0
				letter = k
			end
		}

		if letter == nil
			puts "End of a string"
			if @solution.length ==0
				# Find any starting letter in the map
				letter = @start_map.select{|k,v| v>0}.keys[0]
			else
				# Otherwise, use last letter of last word
				last = @solution.last
				puts "last = #{last}"
				letter = last[last.length-1]
			end
				
			# If no valid letters, give up
			return nil if letter == nil
		end

		# Find the next word starting with this letter
		return get_word( letter  )
    end

	# Find the next word in the sorted word list that
	# begins with the specified letter
    def get_word( letter )
		# Try to find a word that starts with parameter
		word = @sorted_list.select{|l| l[0] == letter ? true : false }[0]
		# If no luck, pass nil back up
		return nil if word == nil
		
		#TODO:appen || lenght
		@sorted_list.delete_at( @sorted_list.index( word ) )

		# Update the start/end counts in the maps
		@start_map[letter] -= 1
		@end_map[ word[word.length-1] ] -= 1
		puts "next word is #{word}"
		
		return word
    end

end