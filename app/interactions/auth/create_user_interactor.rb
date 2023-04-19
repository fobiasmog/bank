module Auth
  class CreateUserInteractor < ActiveInteraction::Base
    string :email
    string :name
    string :avatar_url

    def execute
      ActiveRecord::Base.transaction do
        user = User.find_or_create_by!(email: email) do |user|
          user.name = name
          user.avatar_url = avatar_url
        end
        Account.find_or_create_by!(user: user)
      end
    end
  end
end
