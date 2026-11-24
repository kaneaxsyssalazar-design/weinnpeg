module ApplicationHelper
  def money(amount)
    number_to_currency(amount)
  end

  def product_image(product, size: :thumb, css: "")
    if product.image.attached?
      image_tag product.image.variant(size), class: css, alt: product.name
    else
      tag.div "No image", class: "placeholder-img product-img #{css}"
    end
  end
end
