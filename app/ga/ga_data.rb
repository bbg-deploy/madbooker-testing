
class GaData
  
  attr_accessor :range, :id, :access_token, :profile_id, :ga
  def initialize range: last_30_days, access_token: "", profile_id: "", ga: nil
    self.range              = last_30_days
    self.access_token       = access_token
    self.profile_id         = profile_id
    self.ga                 = ga
  end
  
  
  def visitors range: range
    hit_api "https://www.googleapis.com/analytics/v3/data/ga?metrics=ga:visits&dimensions=ga:date"
#    hit_api "https://www.googleapis.com/analytics/v3/data/ga?metrics=ga:visits,ga:bounces&dimensions=ga:country,ga:region"
  end
  
  
  
  private
  
  def get url
    hit_api url
  end
  
  
  
  def final_url url
     u = add_range url
     u = add_id u
     add_token u
  end
  
  def hit_api url
    final_url = final_url url
    x = 0
    catch :retry do
      h = HTTParty.get final_url
      res = h.parsed_response.with_indifferent_access
      if res[:error] && res[:error][:code] == 401 && x == 0
        x += 1
        a = ga.auth.reauthorize
        if a[:access_token]
          a.ga.access_token = a[:access_token]
          throw :retry 
        end
      end
      res
    end
  end
  
  def add_token url
    "#{puctuate_url url}access_token=#{@access_token}"
  end
  
  def add_id url
    "#{puctuate_url url}ids=ga:#{profile_id}"
  end
  
  def add_range url
    "#{puctuate_url url}start-date=#{range.first.to_s :db}&end-date=#{range.last.to_s :db}"
  end
  
  def last_30_days
    (Date.current - 30)..Date.current
  end
  
  def puctuate_url url
    if url["?"]
      url += "&"
    else
      url += "?"
    end
  end
  
end




