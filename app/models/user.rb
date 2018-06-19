class User < ApplicationRecord
  # Connects this user object to Hydra behaviors.
  include Hydra::User
  # Connects this user object to Role-management behaviors.
  include Hydra::RoleManagement::UserRoles


  # Connects this user object to Hyrax behaviors.
  include Hyrax::User
  include Hyrax::UserUsageStats
  include Hydra::RoleManagement::UserRoles
  include ::IuUserRoles

  # Enable ADS group lookup
  include LDAPGroupsLookup::Behavior
  alias_attribute :ldap_lookup_key, :username

  if Blacklight::Utils.needs_attr_accessible?
    attr_accessible :email, :password, :password_confirmation
  end
  # Connects this user object to Blacklights Bookmarks.
  include Blacklight::User
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :omniauthable, :omniauth_providers => [:cas]

  # Method added by Blacklight; Blacklight uses #to_s on your
  # user class to get a user-displayable login/identifier for
  # the account.
  def to_s
    email
  end

  def groups
    g = roles.map(&:name)
    if Catorax.config[:authorized_ldap_groups].blank?
      g += ['registered'] unless new_record? || guest?
    elsif music_patron?
      g += ['registered']
    end
    g
  end

  def authorized_ldap_member?(force_update = nil)
    if force_update == :force ||
        authorized_membership_updated_at.nil? ||
        authorized_membership_updated_at < Time.now - 1.day
      groups = Catorax.config[:authorized_ldap_groups] || []
      self.authorized_membership = member_of_ldap_group?(groups)
      self.authorized_membership_updated_at = Time.now
      save
    end
    authorized_membership
  end

  def self.find_for_iu_cas(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create! do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = [auth.uid,'@indiana.edu'].join
    end
  end
end
