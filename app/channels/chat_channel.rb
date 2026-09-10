# class ChatChannel < ApplicationCable::Channel
#   def subscribed
#     chat = Chat.find(params[:id])
#     stream_from chat
#   end
# end

# then do ChatChannel.broadcast_to(@chat, @message)
