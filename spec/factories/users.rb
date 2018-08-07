require 'factory_girl'

FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "email-#{srand}@test.com" }
    provider 'cas'
    uid do |user|
      user.email
    end
    factory :admin do
      roles { [Role.where(name: 'admin').first_or_create] }
    end

    factory :campus_patron do
      # All CAS users are campus patrons.
    end

    factory :image_editor do
      roles { [Role.where(name: 'image_editor').first_or_create] }
    end

    factory :editor do
      roles { [Role.where(name: 'editor').first_or_create] }
    end

    factory :fulfiller do
      roles { [Role.where(name: 'fulfiller').first_or_create] }
    end

    factory :curator do
      roles { [Role.where(name: 'curator').first_or_create] }
    end

    factory :complete_reviewer do
      email 'complete@example.com'
      roles { [Role.where(name: 'notify_complete').first_or_create] }
    end

    factory :takedown_reviewer do
      email 'takedown@example.com'
      roles { [Role.where(name: 'notify_takedown').first_or_create] }
    end
  end
end
