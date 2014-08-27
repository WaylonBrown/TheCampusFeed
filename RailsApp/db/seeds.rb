# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'csv'

@@gray_image_threshold = 30
def set_color college
  suckr = ImageSuckr::GoogleSuckr.new
  url = suckr.get_image_url({"q" => college.name + " logo", "as_filetype" => 'png'});
  file = Net::HTTP.get(URI(url))
  img = ChunkyPNG::Image.from_blob file

  frequencies = {}
  (0..img.width-1).step(10) do |w|
    (0..img.height-1).step(10) do |h|
      color = img[w,h]
      if frequencies.has_key? color
        frequencies[color] = frequencies[color] + 1
      else
        frequencies[color] = 1
      end
    end
  end
  frequencies.sort_by{ |color, count| count}
  absdiff = 0
  i = 0
  begin
    winner = ChunkyPNG::Color.parse(frequencies.keys[i])
    red = ChunkyPNG::Color.r(winner)
    gre = ChunkyPNG::Color.g(winner)
    blu = ChunkyPNG::Color.b(winner)
    absdiff = (red-gre).abs + (red-blu).abs
    p absdiff
    i = i + 1
  end while absdiff < @@gray_image_threshold
  college.primary_color = ChunkyPNG::Color.to_hex(winner)
  college.save
end

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
    else
      got_color = false
      while !got_color
        begin
          #set_color @cur
          got_color = true
        rescue
        end
      end
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

Post.create({college_id: cid, text: "this #isnt just your #Avg test"})
Post.create({college_id: cid, text: "This makes me fill in the #letteRstothegameofthenameOfthis"})
(1..50).each {|e|
  testString = rand(1..10) > 5 ? "Test" : "test"
  curPost = Post.create({college_id: cid, text: "This is ##{e}, a ##{testString} post!"})
  (1..10).each {|f|
    Comment.create({post_id: curPost.id, text: "Hi this is a comment."})
  }
}
