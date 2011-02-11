require 'net/http'

class Wepay
  def initialize()
    @http = Net::HTTP.new(APP_CONFIG[:givey]['api_url'])
  end

  def get(path)
    response, data = @http.get(augment_path(path), headers)
    return parsed(data)
  end

  def post(path, body)
    response, data = @http.post(augment_path(path), body.to_json, headers)
    return parsed(data)
  end

  def put(path, body)
    response, data = @http.put(augment_path(path), body.to_json, headers)
    return parsed(data)
  end

  private

    def augment_path(path)
      path = "\/v1" + path if !/^\/v1\//.match(path)
      path
    end

    def headers
      return {'Content-Type' =>'application/json', 'Authorization'  => "BEARER #{APP_CONFIG[:givey]['access_token']}"}
    end

    def parsed(data)
      hash = JSON.parse(data) rescue nil
      return Hashie::Mash.new(hash)
    end
end
