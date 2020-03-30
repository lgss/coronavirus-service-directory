class Service < ApplicationRecord
  geocoded_by :postcode
  after_validation :geocode

  def rough_distance
      if distance < 1
        "Less than a mile away"
      elsif (1 < distance) && (distance < 2)
        "About a mile away"
      else
        "About #{distance.round} miles away"
      end
  end

  def self.categories
    # Urgent food deliveries, Prescription collection, Digital skills setup to support online shopping, Help with shopping
    [
      ["Urgent food deliveries", "Urgent food deliveries"],
      ["Prescription collection", "Prescription collection"],
      ["Digital skills setup to support online shopping", "Digital skills setup to support online shopping"],
      ["Help with shopping", "Help with shopping"],
      ["Tackling loneliness", "Tackling loneliness"],
      ["General Community Support", "General Community Support"]
    ]
  end

end
