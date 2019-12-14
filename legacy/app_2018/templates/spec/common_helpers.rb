module CommonHelpers
  def mock_omniauth(provider)
    fixture = JSON.parse(test_fixture("omniauth/#{provider}.json"))
    OmniAuth.config.add_mock(provider.to_sym, fixture)
  end

  def image_fixture(name)
    File.read(File.join(File.dirname(__FILE__), '..', 'fixtures', 'images', name.to_s))
  end

  def xml_fixture(path)
    Nokogiri::XML(test_fixture(path))
  end

  def test_fixture(path)
    File.read("#{Rails.root}/spec/fixtures/#{path}")
  end
end
