module TheRockTrading 
  module V1
    # specify rock fund_id based on currency traded
    def self.get_fund(tradedCurrency = 'BTC', baseCurrency = 'Linden')
      get_ws = "/v1/funds/#{tradedCurrency}#{baseCurrency}"
      
      # get the json and parse result
      conn = TheRockTrading::Client.new
      x = JSON.parse conn.get(get_ws)
      
      x
    end

    def self.get_quote(type = 'bid', tradedCurrency = 'BTC', baseCurrency = 'EUR')
      get_ws = "/v1/funds/#{tradedCurrency}#{baseCurrency}/ticker"
      
      # get the json and parse result
      conn = TheRockTrading::Client.new
      x = JSON.parse conn.get(get_ws)
      
      price = 0
      if x.class != FalseClass
        if !x.nil? || !x.empty? 
          if type == 'bid'
            price = x["bid"].to_f 
          else
            price = x["ask"].to_f
          end
        end
      end
      price
    end

    # GET TRADES
    def self.get_trades(tradedCurrency, baseCurrency)
      get_ws = "/api/trades/#{tradedCurrency}#{baseCurrency}"
      
      # get the json and parse result
      conn = TheRockTrading::Client.new
      x = JSON.parse conn.get(get_ws)
      
      result = ""
      if x.class != FalseClass
        if !x.nil? || !x.empty?
          x.reverse!
          result = x
        end
      end
      result 
    end
    
    def self.get_orderbook(tradedCurrency, baseCurrency)
      get_ws = "/v1/funds/#{tradedCurrency}#{baseCurrency}/orderbook"
      
      # get the json and parse result
      conn = TheRockTrading::Client.new
      x = JSON.parse conn.get(get_ws)
      
      if x.class != FalseClass
        if !x.nil? || !x.empty? 
          result = x
        end
      end
      # orderbook = {"exchange" => "therock", "bids" => result["bids"], "asks" => result["asks"]}
    end
    
    def self.get_ticker(tradedCurrency, baseCurrency)
      get_ws = "/v1/funds/#{tradedCurrency}#{baseCurrency}/ticker"
      
      # post the json and parse result
      conn = TheRockTrading::Client.new
      x = JSON.parse conn.get(get_ws)
      
      result = ""
      if !x.nil? || !x.empty?
        result = x
        result = x["message"] unless x["message"].nil?
      end
      result
    end
    
    def self.get_tickers
      get_ws = "/api/tickers"
      
      # post the json and parse result
      conn = TheRockTrading::Client.new
      x = JSON.parse conn.get(get_ws)
      
      result = ""
      if x.class != FalseClass
        if !x.nil? || !x.empty?
          result = x["result"]["tickers"]
        end
      end
      result
    end
    
  end
end
