module RubyOuath
  class ProviderClient
    def self.redirect_uri(state)
      params = {
        response_type: 'code',
        client_id: RubyOuath.configuration.client_id,
        scope: RubyOuath.configuration.scopes,
        redirect_uri: RubyOuath.configuration.callback_url,
        state: state
      }
      uri = URI('https://www.linkedin.com/oauth/v2/authorization')
      uri.query = URI.encode_www_form(params)
        
      uri
    end

    def self.get_token_by_code(code)
      data = {
        code: code,
        grant_type: 'authorization_code',
        redirect_uri: RubyOuath.configuration.callback_url,
        client_id: RubyOuath.configuration.client_id,
        client_secret: RubyOuath.configuration.client_secret
      }
    
      res = RestClient.post(
        'https://www.linkedin.com/oauth/v2/accessToken',
        data
      )
    
      JSON.parse(res.body)    
    end

    def self.user_info(token)
      url = 'https://api.linkedin.com/v2/me'

      res = RestClient.get url, {
        Authorization: token
      }

      JSON.parse(res.body)
    end
  end
end