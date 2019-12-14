Fabricator(:fake_thing) do
  name { FFaker::Name.name }
  enabled { FFaker::Boolean.maybe }
  seq { FFaker::Random.rand(100).floor }
end
