module ChatsHelper
  def chat_cover(chat, current_user, width: 50, height: 50, class_attr: "", id_attr: "")
    image =
      case chat.chat_type
      when "self_chat"
        "pp1.png"
      when "group_chat"
        chat.cover.attached? ? chat.cover.variant(resize_to_fill: [ width, height ]) : "pp1.png"
      when "direct_chat"
        recipient = chat.recipient(current_user)
        recipient_profile_picture(recipient, width, height)
      end

    image_tag image,
      width: width,
      height: height,
      class: class_attr,
      id: id_attr
  end

  def recipient_profile_picture(recipient, width, height)
    if recipient&.profile_picture&.attached?
      recipient.profile_picture.variant(resize_to_fill: [ width, height ])
    else
      "pp1.png"
    end
  end

  def chat_name(chat, current_user)
    case chat.chat_type
    when "self_chat"
      "Memo"
    when "group_chat"
      chat.name
    when "direct_chat"
      chat.recipient(current_user)&.name || ""
    end
  end

  def chat_time(chat)
    time = chat.updated_at
    today = Time.current.to_date

    if time.to_date == today
      time.strftime("%H:%M")
    elsif time >= 1.year.ago
      time.strftime("%d.%m")
    else
      time.strftime("%d.%m.%y")
    end
  end

  def chat_preview(chat, current_user)
    if chat.last_message.present?
      preview =
        case chat.last_message.message_type
        when "text_message"
          chat.last_message.text
        when "drawing_message"
          "Drawing"
        when "sticker_message"
          "Sticker"
        end

      chat.last_message.author_id == current_user.id ? "You: " + preview : preview
    else
      chat.self_chat? ? "Your personal space" : "History cleared"
    end
  end
end
