module Serval
  module Helpers
    def response_body
      JSON.parse(last_response.body)
    end

    def stringify_keys(hash)
      return hash unless hash.is_a?(Hash)

      hash.keys.each do |key|
        value = stringify_keys(hash.delete(key))
        value = value.map { |e| stringify_keys(e) } if value.is_a?(Array)
        hash[key.to_s] = value
      end
      hash
    end
  end
end
