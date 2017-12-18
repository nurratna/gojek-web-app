module CalculateDistance
  private
    RAD_PER_DEG = Math::PI / 180
    RM = 6371000 # Earth radius in meters
    KM = 1000

    def distance_between(lat1, lon1, lat2, lon2)
      lat1_rad = lat1.to_f * RAD_PER_DEG
      lat2_rad = lat2.to_f * RAD_PER_DEG
      lon1_rad = lon1.to_f * RAD_PER_DEG
      lon2_rad = lon2.to_f * RAD_PER_DEG

      a = Math.sin((lat2_rad - lat1_rad) / 2) ** 2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin((lon2_rad - lon1_rad) / 2) ** 2
      c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1 - a))

      (RM * c) / KM # Delta in meters
    end
end
