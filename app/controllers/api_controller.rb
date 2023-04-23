# frozen_string_literal: true

class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token
end
