module ApplicationHelper
  def money(amount) = number_to_currency(amount)
    def product_image(product, css: "")
  if product.image.attached?
    image_tag product.image, class: "product-img #{css}", alt: product.name
  else
    content_tag(:div, "No image", class: "product-img placeholder-img #{css}")
  end
end
end
