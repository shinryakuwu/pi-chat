class ChatMembersController < ApplicationController
  def update
    chat_member = Current.user.chat_members.find_by!(chat_id: params[:chat_id])
    chat_member.mark_as_read!

    head :no_content
  end
end
