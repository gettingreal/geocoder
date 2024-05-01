require 'test_helper'

class NaverTest < GeocoderTestCase

  def setup
    super
    Geocoder.configure(lookup: :naver, language: :ko)
    set_api_key!(:naver)
  end

  def test_query_for_address_geocode
    result = Geocoder.search("경기 성남시 분당구 판교역로2번길 10 1층, 지층").first
    assert_equal [37.35951219616309,127.10522081658463], result.coordinates
    assert_equal 37.35951219616309, result.latitude
    assert_equal 127.10522081658463, result.longitude
  end
end