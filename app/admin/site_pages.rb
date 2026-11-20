ActiveAdmin.register_page "Site Pages" do
  menu label: "About & Contact"

  page_action :update, method: :post do
    page = SitePage.find_by!(slug: params[:slug])
    if page.update(title: params[:title], body: params[:body])
      redirect_to admin_site_pages_path, notice: "The #{page.slug} page was updated."
    else
      redirect_to admin_site_pages_path, alert: page.errors.full_messages.to_sentence
    end
  end

  content title: "About & Contact pages" do
    SitePage.order(:slug).each do |page|
      panel "#{page.slug.capitalize} page" do
        form action: admin_site_pages_update_path, method: :post do
          input type: :hidden, name: :authenticity_token, value: form_authenticity_token
          input type: :hidden, name: :slug, value: page.slug
          div do
            label "Title", for: "title_#{page.slug}"
            input type: :text, name: :title, id: "title_#{page.slug}", value: page.title
          end
          div do
            label "Content", for: "body_#{page.slug}"
            textarea page.body, name: :body, id: "body_#{page.slug}", rows: 10
          end
          div do
            input type: :submit, value: "Save #{page.slug} page"
          end
        end
      end
    end
  end
end