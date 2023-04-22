require 'optparse'

class NegativeAmount < StandardError; end
class MissedAgruments < StandardError; end

namespace :credit do
  desc "Credit user by id or email"
  task send: [:environment] do
    search = {}
    amount = 0
    force = false
    sender_id = nil

    opts = OptionParser.new

    opts.on("--user ARG", String, "User Email or ID") do |arg|
      search = arg.to_i.positive? ? { id: arg.to_i } : { email: arg }
    end
    opts.on("--amount ARG", String, "Must be positive") do |arg|
      amount = arg.to_f
    end
    opts.on("--sender-id ARG", Integer, "You can point admin user id as money sender (default: first admin) for soft transfer") do |arg|
      sender_id = arg
    end
    opts.on("--force", "Directly write to account w/o transaction log") do |arg|
      force = true
    end

    args = opts.order!(ARGV) {}
    opts.parse!(args)

    raise NegativeAmount unless amount.positive?

    user = User.find_by!(**search)

    if force
      pp "Force transfer to User:#{user.id}, amount: #{amount}"
      user.account.update!(balance: amount)

      exit
    end

    sender_id ||= User.where(admin: true).first.id

    pp "Soft transfer User:#{sender_id} -> User:#{user.id}, amount: #{amount}"

    transfer = ::Transfers::SendInteractor.run(sender_id: sender_id, receiver_id: user.id, amount: amount)

    pp "Sent"

    exit
  end
end

namespace :user do
  desc "Create user"
  task create: [:environment] do
    name, email, password = [nil, nil, nil]

    opts = OptionParser.new

    opts.on("--email ARG", String, "User Email") { |arg| email = arg }
    opts.on("--name ARG", String, "User Name") { |arg| name = arg }
    opts.on("--password ARG", String, "User Password (plain)") { |arg| password = arg }

    args = opts.order!(ARGV) {}
    opts.parse!(args)

    raise MissedAgruments unless email && name && password

    interaction = ::Auth::CreateUserInteractor.run(email: email, name: name, avatar_url: FFaker::Avatar.image)

    response = Auth0Api.create_user(name: name, email: email, password: password)

    pp interaction.result
    pp response.to_s

    exit
  end

  desc "Create admin user (w/o creating Auth0 user)"
  task create_admin: [:environment] do
    interaction = ::Auth::CreateUserInteractor.run(
      email: FFaker::Internet.unique.email,
      name: FFaker::Name.name,
      avatar_url: FFaker::Avatar.image
    )

    raise interaction.errors unless interaction.valid?

    user = interaction.result

    user.update!(admin: true)
    user.account.update!(balance: 999_999_999)

    pp interaction.result

    exit
  end
end
