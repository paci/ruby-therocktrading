require 'net/http'
require 'net/https'
require 'rubygems'
require 'yaml'
require 'json'

require 'pp'

module TheRockTrading
  class Client
    attr_accessor :host, :post_ws, :port, :user, :user_id, :pass, :api_key, :secret, :use_ssl

    def initialize
      #settings = YAML::load_file("config/api_keys.yml")
      settings = TheRockTrading::Configuration.as_h
      @user = settings[:user]
      @user_id = settings[:user_id]
      @pass = settings[:pass]
      @host = settings[:host]
      @port = settings[:port]
      @api_key = settings[:api_key]
      @secret = settings[:secret]
      @use_ssl = settings[:use_ssl]
    end
  
    def to_s
      "Host is: #{@host}, port: #{@port}, user: #{@user}, pass: #{@pass}, api_key: #{@api_key}"
    end

    def post(post_ws, payload)
      http = Net::HTTP.new(@host, @port)
      http.use_ssl = @use_ssl
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      payload.merge!({"username" => @user,
      "password" => @pass,
      "api_key" => @api_key})

      http.start do |http|
        req = Net::HTTP::Post.new(post_ws, initheader = {'Content-Type' =>'application/json'})
        req.basic_auth @user, @pass
        req.body = payload.to_json
        response = http.request req
        response.body
      end
    end

    def request_auth(of_type, post_ws, payload)
      http = Net::HTTP.new(@host, @port)
      http.use_ssl = @use_ssl
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      http.start do |http|
        url_path = "/v1/" + post_ws
        req = Net::HTTP::Post.new(url_path, initheader = {'Content-Type' =>'application/json'}) if of_type == "POST"
        req = Net::HTTP::Get.new(url_path, initheader = {'Content-Type' =>'application/json'}) if of_type == "GET"
        req = Net::HTTP::Delete.new(url_path, initheader = {'Content-Type' =>'application/json'}) if of_type == "DELETE"
        #req.basic_auth @user, @pass
        req.body = payload.to_json

        full_path = "http://"
        full_path = "https://" if @use_ssl == true
        full_path += @host
        full_path += ":#{@port}" if @port.to_i != 443
        full_path += url_path

        n = nonce
        h = headers(n.to_s + full_path).to_a
        req.add_field "X-TRT-KEY", h[0][1].to_s
        req.add_field "X-TRT-SIGN", h[1][1].to_s
        req.add_field "X-TRT-NONCE", n.to_i
        response = http.request req
        response.body
      end
    end

    def get(get_ws, payload = nil)
      req = Net::HTTP::Get.new(get_ws)
      https = Net::HTTP.new(@host, @port)
      https.use_ssl = @use_ssl
      https.verify_mode = OpenSSL::SSL::VERIFY_NONE
      #https.ssl_version="SSLv3"
      response = https.start { |https| https.request(req) }

      if response.code == "301" # moved permanently
        url = URI.parse(response.header['location'])
        req = Net::HTTP::Get.new(url.path)
        req.body = payload
        response = Net::HTTP.new(url.host, url.port).start {|http| http.request(req) }
      end  
      response.body
    end

    private
    def headers(request)
      #request = request.collect{|k, v| "#{k}=#{v}"} * '&'
      hmac = OpenSSL::HMAC.new(@secret,
                               OpenSSL::Digest::SHA512.new)
      signature = hmac.update request
      {'Key' => @api_key, 'Sign' => signature}
    end
    
    def body_from_options(options)
      add_nonce(options).collect{|k, v| "#{k}=#{v}"} * '&'
    end
    
    def nonce
      # stupid way to make sure we do not hit API rate limits
      sleep 0.15
      if @nonce
        @nonce = @nonce + 1
      else
        @nonce = (Time.now.to_f * 1000000).to_i - 1435000000000000
        # @nonce = (Time.now.to_f / 250 * 1000 - 4250000000).to_i
        #@nonce = Time.now.to_i
      end
      
      @nonce
    end

  end
end
