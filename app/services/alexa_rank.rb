class AlexaRank
  def initialize(url:)
    @url = url
  end

  def consult_ranking
    begin
      @uri = URI.parse(@url)
      @domain = PublicSuffix.parse(@uri.host)
      response = HTTParty.get('https://awis.api.alexa.com/api?Action=urlInfo&ResponseGroup=Rank&Url='+@domain.domain,
                              headers: {
                                'Accept' => 'application/json',
                                'x-api-key' => '8T7SlYd7Tp16a9VPBovC26LXGhosXjeM97CLbUUv',
                              })
      response_json = Hash.from_xml(response&.body)
      response_json['Awis']['Results']['Result']['Alexa']['TrafficData']['Rank']
    rescue
      0
    end
  end
end