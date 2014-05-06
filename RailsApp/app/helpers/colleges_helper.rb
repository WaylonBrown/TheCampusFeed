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

end
