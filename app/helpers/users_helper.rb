module UsersHelper
  def profile_picture(user, width: 50, height: 50, class_attr: "", id_attr: "")
    image =
      if user.profile_picture.attached?
        user.profile_picture.variant(resize_to_fill: [ width, height ])
      else
        "pp.png"
      end

    image_tag image,
      width: width,
      height: height,
      class: class_attr,
      id: id_attr
  end
end
