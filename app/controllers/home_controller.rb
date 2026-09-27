class HomeController < ApplicationController
  def show
    # TODO: maybe make this action responsible for showing navigation header later
    @user = Current.user
  end
end
