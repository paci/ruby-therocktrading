module TheRockTrading 
  module V1
    def self.get_orders(tradedCurrency = nil, baseCurrency = nil, side = nil, after = nil)

      post_ws = "funds/#{tradedCurrency}#{baseCurrency}/orders"
      
      payload = {} # just an empty payload
 
      payload.merge!({"side" => side}) unless side.nil?
      payload.merge!({"per_page" => 200})
      payload.merge!({"after" => after}) unless after.nil?


      conn = TheRockTrading::Client.new
      x = JSON.parse conn.request_auth("GET", post_ws, payload)
      
      result = Array.new
      if x.class != FalseClass
        if !x.nil? || !x.empty? 
          result = x["orders"]
        end
      end
      result
    end

    def self.get_mytrades(tradedCurrency = nil, baseCurrency = nil, trade_id = nil, after = nil)
      post_ws = "funds/#{tradedCurrency}#{baseCurrency}/trades"
      
      payload = {} # just an empty payload
 
      payload.merge!({"trade_id" => trade_id}) unless trade_id.nil?
      payload.merge!({"after" => after})       unless after.nil?
      payload.merge!({"per_page" => 200})


      conn = TheRockTrading::Client.new
      x = JSON.parse conn.request_auth("GET", post_ws, payload)
      
      result = Array.new
      if x.class != FalseClass
        if !x.nil? && !x.empty? && x["errors"].nil? 
          result = x["trades"]
        end
      end
      result
    end

    
    def self.place_order(side, amount, price, tradedCurrency, baseCurrency, close_on = nil, leverage = nil, position_id = nil)
      post_ws = "funds/#{tradedCurrency}#{baseCurrency}/orders"
      payload = {
        "side" => side.downcase,
        "fund_id" => "#{tradedCurrency}#{baseCurrency}",
        "amount" => amount,
        "price" => price
      }

      payload.merge!({"leverage" => leverage}) unless leverage.nil?
      payload.merge!({"position_id" => position_id}) unless position_id.nil?
      payload.merge!({"close_on" => close_on}) unless close_on.nil?
      
      # post the json and parse result
      conn = TheRockTrading::Client.new
      x = JSON.parse conn.request_auth("POST", post_ws, payload)

      result = ""
      if x.class != FalseClass
        if (!x.nil? || !x.empty?) && x["errors"].nil?
          result = x["id"]
        else
          result = x["errors"][0] unless x["errors"].nil?
        end
      end
      result
    end
    
    def self.cancel_order(tradedCurrency, baseCurrency, id)
      post_ws = "funds/#{tradedCurrency}#{baseCurrency}/orders/#{id}"
      payload = {
      }
      
      # post the json and parse result
      conn = TheRockTrading::Client.new
      x = conn.request_auth("DELETE", post_ws, payload)
      x
    end
    
    def self.get_discountlevel(curr)
      post_ws = "/api/get_discountlevel"
      payload = {
        "type_of_currency" => curr
      }
      
      # post the json and parse result
      conn = TheRockTrading::Client.new
      x = JSON.parse conn.post(post_ws, payload)
      x
    end
    
  end
end
