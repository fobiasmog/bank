# frozen_string_literal: true

module Auth
  class CreateUserInteractor < ActiveInteraction::Base
    string :email
    string :name
    string :avatar_url

    attr_reader :user

    def execute
      ActiveRecord::Base.transaction do
        @user = User.create_with(name: name, avatar_url: avatar_url).find_or_create_by!(email: email)

        Account.find_or_create_by!(user_id: user.id)
      end

      user
    end
  end
end
