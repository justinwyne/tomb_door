require "PlateSolver.rb"

class TombController < ApplicationController

	def index
  
		if params[:q]
			@input = params[:q]
			@word_list = params[:q].split(' ')

			plate_solver = PlateSolver.new( @word_list )

			@output = plate_solver.solve
			
		end
	end

end
