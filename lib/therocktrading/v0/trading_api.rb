module TheRockTrading 
  module V0
    def self.get_balance(curr = nil)
      if curr == "DOG"
	curr = "DOGE"
      end
      post_ws = "/api/get_balance"
      # no json in this case
      payload = {}
      payload = {
        "type_of_currency" => curr
      } unless curr.nil?
      
      # post the json and parse result
      conn = TheRockTrading::Client.new
      x = JSON.parse conn.post(post_ws, payload)
      
      result = ""
      if x.class != FalseClass
        if !x.nil? || !x.empty? 
          result = x["result"][0]["trading_balance"]
        end
      end
      result
    end
    
    def self.get_orders(tradedCurrency = nil, baseCurrency = nil)
      post_ws = "/api/get_orders"
      payload = {
        "selection" => "OPEN"
      }
      payload = {
        "fund_name" => "#{tradedCurrency}#{baseCurrency}",
        "selection" => "OPEN"
      } unless tradedCurrency.nil? || baseCurrency.nil?
      
      
      # post the json and parse result
      conn = TheRockTrading::Client.new
      x = JSON.parse conn.post(post_ws, payload)
      
      result = ""
      if x.class != FalseClass
        if !x["result"].nil?
          if x["result"].is_a? Hash # is an ERROR"
            result = x["result"]["orders"]
          else
            result = []
          end
        end
      end
      result
    end
    
    def self.place_order(type, amount, price, tradedCurrency, baseCurrency)
      post_ws = "/api/place_order"
      ordertype = 'S'
      if type == "BUY"
        ordertype = 'B'
      end
      payload = {
        "order_type" => ordertype,
        "fund_name" => "#{tradedCurrency}#{baseCurrency}",
        "amount" => amount,
        "price" => price
      }
      
      # post the json and parse result
      conn = TheRockTrading::Client.new
      x = JSON.parse conn.post(post_ws, payload)

      result = ""
      if x.class != FalseClass
        if !x["result"].nil?
          result = x["result"][0]
        end
      end
      result
    end
    
    def self.cancel_order(id)
      post_ws = "/api/cancel_order"
      payload = {
        "order_id" => "#{id}"
      }
      
      # post the json and parse result
      conn = TheRockTrading::Client.new
      x = JSON.parse conn.post(post_ws, payload)
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
    
    def self.get_mytrades
      post_ws = "/api/get_trades"
      payload = {
      }
      
      # post the json and parse result
      conn = TheRockTrading::Client.new
      x = JSON.parse conn.post(post_ws, payload)
      
      result = ""
      if x.class != FalseClass
        if !x["result"].nil?
          #pp x["result"]
          if x["result"]["trades"].nil?
            result = []
          else
            result = x["result"]["trades"]
          end
        end
      end
      result
    end
  end
end
