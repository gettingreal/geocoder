require 'geocoder/lookups/base'
require 'geocoder/results/naver'

module Geocoder::Lookup
  class Naver < Base

    def name
      "Naver"
    end

    def required_api_key_parts
      [:client_id, :client_secret]
    end

    def supported_protocols
      [:https]
    end

    private # make requests with: http://[endpoint]?[query_string]

    def http_headers
      super.merge(
        "X-NCP-APIGW-API-KEY-ID" => configuration.api_key[:client_id],
        "X-NCP-APIGW-API-KEY" => configuration.api_key[:client_secret],
      )
    end

    def base_query_url(query)
      path = query.reverse_geocode? ? 'map-reversegeocode/v2/gc' : 'map-geocode/v2/geocode'
      "#{protocol}://naveropenapi.apigw.ntruss.com/#{path}?"
    end

    def query_url_params(query)
      params = {}

      if query.reverse_geocode?
        params[:coords] = query.coordinates.reverse.join(',')
      else
        params[:query] = query.sanitized_text
        params[:language] = query.language || configuration.language == :ko ? 'kor' : 'eng' # supports ko, en
      end

      params.merge(super)
    end

    def results(query)
      return [] unless doc = fetch_data(query)

      if doc = doc['addresses']
        doc
      else
        Geocoder.log(:warn, "Naver Geocoding API error: unexpected response format.")
        []
      end
    end
  end
end