module Auth
  class CreateUserInteractor < ActiveInteraction::Base
    string :email
    string :name
    string :avatar_url

    def execute
      ActiveRecord::Base.transaction do
        user = User.find_or_create_by!(email: email).with(name: name, avatar_url: avatar_url)
        Account.find_or_create_by!(user: user)
      end
    end
  end
end