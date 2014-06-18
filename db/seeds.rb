# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'csv'

def sanitizeName(name)
  ret = name
  if name.start_with? "The "
    ret = name[4..-1] #chop that off!
  end

  if /(.* .) & (..*)/.match(ret)
    ret = $1 + "&" + $2
  end

  return ret
end

@@smallestSizeIncluded = 12
def importFromFile(lim = -1)
  #imports from the 2012 
  @i = 0
  @data = CSV.foreach("app/assets/hd2012.csv", encoding: "iso-8859-1:UTF-8" ){ |row|




    if 0 == @i #don't use first row
      @i += 1
      next
    end



    if Integer(row[49]) < @@smallestSizeIncluded #don't use small schools
      next
    end

    name = row[1]
    sanitizedName = sanitizeName(name)



    @params = Hash.new
    @params[:name] = sanitizedName
    @params[:lat] = row[-1]
    @params[:lon] = row[-2] # database provided as lon then lat.. wtf
    @params[:size] = row[49]
    @cur = College.new(@params)
    if !@cur.save
      puts 'shit shit shit' #this shouldn't happen ;)
    end
    if lim != -1 and @i > lim
      break
    end

    @i += 1
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

College.destroy_all
if Rails.env.production?
  importFromFile
else
  importFromFile 10
end


Post.destroy_all
Comment.destroy_all

cid = College.first.id
(1..50).each {|e|
  curPost = Post.create({college_id: cid, text: "This is ##{e}, a #test post!"})
  (1..10).each {|f|
    Comment.create({post_id: curPost.id, text: "Hi this is a comment."})
  }
}
