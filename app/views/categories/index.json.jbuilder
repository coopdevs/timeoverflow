json.array!(@categories) do |c|
  json.partial! "category", category: c
end
