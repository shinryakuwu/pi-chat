module UsersHelper
  def profile_picture(user, width: 50, height: 50, class_attr: "", id_attr: "")
    if user.profile_picture.attached?
      image = user.profile_picture.variant(resize_to_fill: [ width, height ])

      image_tag(
        rails_blob_path(image, only_path: true),
        width: width,
        height: height,
        class: class_attr,
        id: id_attr
      )
    else
      image_tag(
        default_profile_picture(user),
        width: width,
        height: height,
        class: class_attr,
        id: id_attr
      )
    end
  end

  private

  def default_profile_picture(user)
    user.deleted_at? ? "deleted.png" : "empty.png"
  end
end
