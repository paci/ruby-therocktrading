module TheRockTrading
  class Configuration
    attr_accessor :host, :post_ws, :port, :user, :user_id, :pass, :api_key, :secret, :use_ssl
    def self.as_h
      c = configuration 
      {
        host:    c.host,
        post_ws: c.post_ws,
        port:    c.port,
        user:    c.user,
        user_id: c.user_id,
        pass:    c.pass,
        api_key: c.api_key,
        secret:  c.secret,
        use_ssl: c.use_ssl
      }
    end
    def self.configuration
      @configuration ||= Configuration.new
    end
    def self.configure
      yield(configuration) if block_given?
    end
  end
end
