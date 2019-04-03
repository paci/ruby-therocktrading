module TheRockTrading 
  module V0
    # specify rock fund_id based on currency traded
    def self.get_fund(tradedCurrency = 'BTC', baseCurrency = 'Linden')
      fund_id = 7
      if tradedCurrency == 'BTC'
        if baseCurrency == 'Linden'
          fund_id = 7
        end
        if baseCurrency == 'EUR'
          fund_id = 9
        end
        if baseCurrency == 'USD'
          fund_id = 10
        end
      end
      if tradedCurrency == 'EUR'
        if baseCurrency == 'Linden'
          fund_id = 11
        end
      end
      if tradedCurrency == 'USD'
        if baseCurrency == 'Linden'
          fund_id = 12
        end
      end
      fund_id
    end

        # GET BID OR ASK FROM THEROCKTRADING
    def self.get_quote(type = 'bid', tradedCurrency = 'BTC', baseCurrency = 'EUR')
      get_ws = "/api/ticker/#{tradedCurrency}#{baseCurrency}"
      
      # get the json and parse result
      conn = TheRockTrading::Client.new
      conn.to_s
      x = JSON.parse conn.get(get_ws)
      
      price = 0
      if x.class != FalseClass
        if !x.nil? || !x.empty? 
          x["result"].each do |data, value|
            if type == 'bid'
              price = data["bid"].to_f 
            else
              price = data["ask"].to_f
            end
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
      get_ws = "/api/orderbook/#{tradedCurrency}#{baseCurrency}"
      
      # get the json and parse result
      conn = TheRockTrading::Client.new
      x = JSON.parse conn.get(get_ws)
      
      result = ""
      if x.class != FalseClass
        if !x.nil? || !x.empty? 
          result = x
        end
      end
      orderbook = {"exchange" => "therock", "bids" => result["bids"], "asks" => result["asks"]}
    end
    
    def self.get_ticker(tradedCurrency, baseCurrency)
      get_ws = "/api/ticker/#{tradedCurrency}#{baseCurrency}"
      
      # post the json and parse result
      conn = TheRockTrading::Client.new
      x = JSON.parse conn.get(get_ws)
      
      result = ""
      if x.class != FalseClass
        if !x.nil? || !x.empty? 
          result = x["result"][0]
        end
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
