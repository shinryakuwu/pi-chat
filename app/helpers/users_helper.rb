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
        "empty.png",
        width: width,
        height: height,
        class: class_attr,
        id: id_attr
      )
    end
  end
end
