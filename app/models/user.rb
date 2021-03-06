class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable

  has_many :videos, :dependent => :destroy
  has_one :profile, :dependent => :destroy
  has_many :preferences, :dependent => :destroy

  after_create  :build_profile

  def is_admin?
   self.admin == true
  end

  private

  def build_profile
    user = User.find(User.last.id)
    user.profile = Profile.create(full_name: user.name)
    user.save
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user
      user.name = auth.extra.raw_info.name
      user.uid = auth.uid
      user.provider = auth.provider
      user.access_token = auth.credentials.token
      user.save
      return user
    else
      registered_user = User.where(:email => auth.info.email).first
      if registered_user
        registered_user.name = auth.extra.raw_info.name
        registered_user.uid = auth.uid
        registered_user.provider = auth.provider
        registered_user.access_token = auth.credentials.token
        registered_user.save
        return registered_user
      else
        user = User.create(name:auth.extra.raw_info.name,
                            provider:auth.provider,
                            uid:auth.uid,
                            email:auth.info.email,
                            access_token: auth.credentials.token,
                            password:Devise.friendly_token[0,20]
                          )
      end    end
  end

end

