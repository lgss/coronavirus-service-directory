module LogoutHelper
    def logout_url
      domain = ENV.fetch("AUTH0_CLIENT_URI")
      client_id = ENV.fetch("AUTH0_CLIENT_ID")

      request_params = {
        returnTo: root_url,
        client_id: client_id
      }
  
      URI::HTTPS.build(host: domain, path: '/v2/logout', query: to_query(request_params))
    end
  
    private
  
    def to_query(hash)
      hash.map { |k, v| "#{k}=#{CGI.escape(v)}" unless v.nil? }.reject(&:nil?).join('&')
    end
  end