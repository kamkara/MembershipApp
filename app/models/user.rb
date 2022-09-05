class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, 
        :trackable, authentication_keys: [:logged]

 ################## VALIDATES  ###############
  before_validation :user_student?,
                    :user_teacher?,
                    :user_ambassador?,
                    :user_team?,
                    :full_name?,
                    on: :create
  
   validates :contact,
              uniqueness: true, 
              numericality: { only_integer: true }
              
              
   validates :user_role,
              inclusion: { in: %w(Student Teacher Team),
                    message: "%{value} acces non identifier" }
    
    validates :user_class_status, 
              inclusion: { in: %w(Non-Doublant Doublant),
                          message: "%{value} invalide"}
    #validates :referral_in, :referral_up, length: {is:5}
   ############# CUSTOMIZE ###############""
   
   def user_student?
    if self.user_role == "Student"
      self.email = "#{self.matricule}@gmail.com" # if user.role == "Student"
      self.password = "#{self.contact}"
     #protokoll :referral_up, :pattern => "%MS%M#" # chaque "00S0000"
    end
  end    

  def user_teacher?
    if self.user_role == "Teacher"
      self.matricule = "#{self.contact}T"      
      #protokoll :referral_up, :pattern => "%MT%M#" # chaque "00T0000"
    end
  end

  def user_ambassador?
    if self.user_role == "Ambassador"
     # protokoll :referral_up, :pattern => "%MA%M#" # chaque "00A0000"
     self.matricule = "#{self.contact}A"      
      
    end
  end
  def user_team?
    if self.user_role == "Team"
      #referral_up = protokoll :counter_user, :pattern => "%ME%M#" # chaque "00E0000"
      self.city_name = "LNCLASS HQ"
      self.school_name = "LNCLASS SCHOOL"
      self.matricule = "#{self.contact}T"      
    end
  end
#FULL_NAME
  def full_name?
    self.full_name = "#{self.first_name} #{self.last_name}" 
  end 

################## SLUG ###############
  extend FriendlyId
  friendly_id :user_slugged, use: :slugged
  
  def user_slugged
    [
      :full_name,
    [:full_name, :contact]
    ]
  end
  ################## END SLUGGED #########

  ################## BEFORE SAVE  #########
  before_save do
    self.contact            = contact.strip.squeeze(" ")
    self.first_name         = first_name.strip.squeeze(" ").downcase.capitalize
    self.last_name          = last_name.strip.squeeze(" ").downcase.capitalize
  end
    
  ################## LOGGED  #########
  #permet la connexion avec le matricule
  def logged
    @logged || self.matricule || self.email
  end
  
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if logged = conditions.delete(:logged)
      where(conditions.to_h).where(["lower(matricule) = :value OR lower(email) = :value", { :value => logged.downcase }]).first
    elsif conditions.has_key?(:matricule) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end
  ################## End Logged  #########
        
end
