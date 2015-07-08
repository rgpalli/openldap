#
# Cookbook Name:: OpenLdap
# Library:: default
#
# Copyright 2015, Relevance PVT LTD, Inc.
#
# All rights reserved - Do Not Redistribute
#

class UpdateFile
	def self.editFile(filepath, key, subVal, instruct)
			File.open(filepath, 'r+') do |file1|
				File.foreach(filepath) do |line|
			  		if line.start_with? key
			  			file1.puts line if instruct.eql? "add"
			  			file1.puts subVal
			  		else
			  			file1.puts line
			  		end
			  	end
			end
	end


	def self.propNotExists(filepath, key)
		return !(File.read(filepath).include? key)
	end

	def self.addParam(filepath, key, subVal)
		editFile(filepath, key, subVal, "add")
	end

	def self.updateParam(filepath, key, subVal)
		editFile(filepath, key, subVal, "update")
	end
end