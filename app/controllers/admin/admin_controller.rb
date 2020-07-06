# typed: false
module Admin
  class AdminController < ApplicationController
    before_action :restrict_access_to_admins

    private

    def restrict_access_to_admins
      redirect_to root_path and return unless current_user&.admin
    end
  end
end
