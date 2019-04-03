module TheRockTrading 
  module V1
    def self.get_positions(tradedCurrency = nil, baseCurrency = nil, status = nil, type = nil)
      post_ws = "funds/#{tradedCurrency}#{baseCurrency}/positions"
      
      payload = {} # just an empty payload
 
      payload.merge!({"status" => status}) unless status.nil?
      payload.merge!({"type" => type}) unless type.nil?

      conn = TheRockTrading::Client.new
      x = JSON.parse conn.request_auth("GET", post_ws, payload)
      
      result = Array.new
      if x.class != FalseClass
        if !x.nil? || !x.empty? 
          result = x["positions"]
        end
      end
      result
    end

    def self.get_position(tradedCurrency = nil, baseCurrency = nil, position_id = nil)
      post_ws = "funds/#{tradedCurrency}#{baseCurrency}/positions/#{position_id}"
      payload = {} # just an empty payload
 
      conn = TheRockTrading::Client.new
      x = JSON.parse conn.request_auth("GET", post_ws, payload)
      
      result = Array.new
      #puts "POSITIONS DEBUG: " + x.to_s      
      debug(x)      
      if x.class != FalseClass
        if !x.nil? || !x.empty? 
          result = x
        end
      end
      result
    end

  end
end
