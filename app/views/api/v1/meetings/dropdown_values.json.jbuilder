json.set! :locations do 
  json.array Location.all.each do |location|
    json.(location, :id, :name)
    json.set! :rooms do 
      json.array location.rooms do |room|
        json.(room, :id, :name)
      end
    end
  end
end