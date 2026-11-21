ActiveAdmin.register Product do
  permit_params :name, :description, :price, :stock_quantity, :on_sale, :category_id, :image

  index do
    selectable_column
    id_column
    column :name
    column("Image") { |p| image_tag(p.image, width: 60) if p.image.attached? }
    column :category
    column :price
    column :stock_quantity
    column :on_sale
    actions
  end

  filter :category
  filter :name
  filter :on_sale

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :category
      f.input :name
      f.input :description
      f.input :price
      f.input :stock_quantity
      f.input :on_sale
      f.input :image, as: :file, hint: (f.object.image.attached? ? image_tag(f.object.image, width: 120) : "No image yet")
    end
    f.actions
  end
end
