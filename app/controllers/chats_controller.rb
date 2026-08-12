class ChatsController < ApplicationController
  def index
    @chats = Current.user.chats
  end
end
