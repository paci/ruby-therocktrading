module TheRockTrading 
  module V1

    def self.get_discount(curr = nil)
      post_ws = "discounts"
      payload = {}

      begin
        post_ws += "/" + curr
      end unless curr.nil?
      # get the json and parse result
      conn = TheRockTrading::Client.new
      x = JSON.parse conn.request_auth("GET", post_ws, payload)

      if x.class != FalseClass
        if !x.nil? || !x.empty?
          result = x
        end
      end
      result
    end

    def self.get_balance(curr = nil)
      if curr == "DOG"
	curr = "DOGE"
      end
      post_ws = "balances"
      payload = {}

      begin 
        post_ws = "balances/" + curr
        payload = {
          "type_of_currency" => curr
        }
      end unless curr.nil?
      
      # post the json and parse result
      conn = TheRockTrading::Client.new
      x = JSON.parse conn.request_auth("GET", post_ws, payload)

      debug(x)
      if x.class != FalseClass
        if !x.nil? || !x.empty? 
          result = x
          if !curr.nil?
            result = x["trading_balance"] 
            result = x["message"] if !x["message"].nil? 
          end
        end
      end
      result
    end

    def self.get_mytrades(id = nil)
      post_ws = "funds/#{id}/trades"
      payload = {}
      begin
        payload = {
          "since" => since
        }
      end unless since.nil?
      
      conn = TheRockTrading::Client.new
      x = JSON.parse conn.request_auth("GET",post_ws, payload)

      if x.class != FalseClass
        if !x.nil? || !x.empty? 
          result = x
          if x.is_a?(Hash)
            result = x["message"] if !x["message"].nil? 
          end
        end
      end
    end

  end
end
