class Authentication < ActiveRecord::Base
  belongs_to :user
  
  # def self.create_with_omniauth(auth)
  #    create! do |a|
  #      a.provider = auth["provider"]
  #      a.uid = auth["uid"]
  #    end
  #  end
end
