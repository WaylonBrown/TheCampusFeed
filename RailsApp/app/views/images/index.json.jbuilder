json.array!(@images) do |image|
  json.extract! image, :id, :uri
  json.url image_url(image, format: :json)
end
