# frozen_string_literal: true

namespace :status do
  task :get do

    p = ENV['ZENDESKPASSWORD']
    options = { basic_auth: { username: 'hello@rabidtech.co.nz', password: p } }
    url = 'https://rabidtech.zendesk.com/api/v2/search.json'
    url_query = '?query=type:ticket status:open type:ticket status:pending'

    puts p
    puts options
    puts url
    puts url_query
    
    x = HTTParty.get("#{url}#{url_query}", options)
    response = JSON.parse(x.body)
    puts response
  end
end
