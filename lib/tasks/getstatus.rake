# frozen_string_literal: true

namespace :status do
  task :get do
    p = ENV['ZENDESKPASSWORD']
    options = { basic_auth: { username: 'hello@rabidtech.co.nz', password: p } }
    url = 'https://rabidtech.zendesk.com/api/v2/'
    url_query = 'search.json?query=type:ticket status:open type:ticket status:pending'
    url_query_comments = '/comments.json?sort_order=desc'
    url_to_view_in_browser = 'https://rabidtech.zendesk.com/agent/tickets/'

    private_comments = []

    x = HTTParty.get("#{url}#{url_query}", options)
    response = JSON.parse(x.body)

    response['results'].each do |r|
      id = r['id']
      requester_id = r['requester_id']
      requester = JSON.parse(HTTParty.get("https://rabidtech.zendesk.com/api/v2/users/#{requester_id}.json", options).body)['user']['name']

      x = HTTParty.get("#{url}tickets/#{id}/#{url_query_comments}", options)
      comments = JSON.parse x.body

      private_comments.append(url_to_view_in_browser + id.to_s + ' - requested by ' + requester + ': ' + get_most_recent_private_comment(comments) +"\n\n")
    end
    puts private_comments
  end

  def get_most_recent_private_comment(comments)
    most_recent = nil

    comments['comments'].each do |c|
      unless c['public']
        most_recent = c['body']
        break
      end
    end

    most_recent
  end
end
