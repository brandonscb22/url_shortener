json.extract! link, :id, :title, :description, :url, :short_code, :alexa_rank, :created_at, :updated_at
#json.url link_url(link, format: :json)
json.short_code @base_url_protocol + @base_url + '/' + link.short_code