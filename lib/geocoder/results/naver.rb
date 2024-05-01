require 'geocoder/results/base'

module Geocoder::Result
  class Naver < Base
    def coordinates
      [@data['y'].to_f, @data['x'].to_f]
    end

    def address
      ""
    end
  end
end