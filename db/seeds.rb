# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'csv'

def importFromFile(lim = -1)
  #imports from the 2012 
  @i = 0
  @data = CSV.foreach("app/assets/hd2012.csv", encoding: "iso-8859-1:UTF-8" ){ |row|
    @i += 1

    if @i == 1
      next
    end


    @params = Hash.new
    @params[:name] = row[1]
    @params[:lat] = row[-1]
    @params[:lon] = row[-2] # database provided as lon then lat.. wtf
    @params[:size] = row[49] # column AX
    @cur = Api::V1::College.new(@params)
    if !@cur.save
      puts 'shit shit shit' #this shouldn't happen ;)
    end
    if lim != -1 and @i > lim
      break
    end
  }
end

def importFromWrongFile
  #no longer using this!
  @data = JSON.parse(File.read("app/assets/export.json"))
  @data.each_key{|x| puts x}
  @i = 0
  @data["elements"].each{ |x|

    if x.has_key? "tags" and x["tags"].has_key? "name" and ((x["tags"].has_key? "building" and x["tags"]["building"] == "no") or !x["tags"].has_key? "building")
      @i = @i + 1
      puts x["tags"]["name"]
      #puts "asdf"
    end
  }
end

Api::V1::College.destroy_all
if Rails.env.production?
  importFromFile
else
  importFromFile 10
end
