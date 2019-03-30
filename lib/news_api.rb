require 'net/http'
require 'uri'
require 'date'
require 'json'

class NewsAPI

  ##
  # Creates object for accessing data from https://newsapi.org/
  def initialize(api_key)
    ##
    #
    @api_key = api_key
    @base_url = 'https://newsapi.org/v2/everything?apiKey=' + @api_key
  end

  def get(search_key, query_params = {})
    uri_query = '&q=' + search_key
    if query_params.key? 'from'
      begin
        date = query_params['from']
        Date.parse(date)
      rescue ArgumentError
        date = Date.today - 30
        puts 'Invalid date format, defaulting to ' + date
      end
      uri_query += '&from=' + date
    end

    if query_params.key? 'sortBy'
      sort_options = %w(relevancy popularity publishedAt)

      sort_key = query_params['sortBy']

      if sort_options.include? sort_key
        uri_query += '&sortBy' + sort_key
      end
    end

    puts @base_url + uri_query

    JSON.parse(Net::HTTP.get URI(@base_url + uri_query))
  end
end