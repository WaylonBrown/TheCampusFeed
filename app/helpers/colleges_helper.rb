require 'csv'


module CollegesHelper

  def toRads(deg)
    deg * Math::PI / 180
  end

  @@EarthRadius = 6371 #km
  def distance(lat1, lon1, lat2, lon2)
    @phi1 = toRads(lat1)
    @phi2 = toRads(lat2)
    @deltaPhi = toRads(lat2-lat1)
    @deltaLambda = toRads(lon2-lon1) #gettin frat

    @a = Math.sin(@deltaPhi/2) * Math.sin(@deltaPhi/2) + 
      Math.cos(@phi1) * Math.cos(@phi2) * 
      Math.sin(@deltaLambda/2) * Math.sin(@deltaLambda/2) #wow
    @c = 2 * Math.atan2(Math.sqrt(@a), Math.sqrt(1-@a))

    @@EarthRadius * @c #returns in km!
  end

  def destroyAll
    #yikes, careful
    Api::V1::College.destroy_all
  end

  def importFromFile
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
      @cur = Api::V1::College.new(@params)
      if !@cur.save
        puts 'shit shit shit' #this shouldn't happen ;)
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
    puts @i
    puts "Asdfasdfasdfasdfasdfasdfasdfasdfas"
  end
end
