ActiveAdmin.register Order do
  permit_params :status
  actions :index, :show, :edit, :update
end
