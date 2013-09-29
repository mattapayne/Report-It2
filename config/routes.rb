ReportIt::Application.routes.draw do
  root to: "home#index"
  controller :home do
    get 'about' => :about
    get 'contact' => :contact
    post 'message' => :create
  end
  controller :sessions do
    post 'login' => :create
    delete 'logout' => :destroy
  end
  controller :dashboard do
    get 'dashboard' => :index
  end
  controller :registration do
    get 'register' => :new
    post 'register' => :create
  end
  controller :account_validation do
    get 'validate_account/:token' => :new, as: 'validate_account'
  end
  controller :forgot_password do
    get 'forgot_password' => :new
    post 'forgot_password' => :create
    get 'password_reset/:token' => :reset, as: 'password_reset'
  end
  controller :my_account do
    get 'my_account' => :index  
  end
  controller :reports do
    get 'reports' => :index
    get 'reports/edit/:id' => :edit, as: :edit_report #renders the view for editing one
    get 'reports/edit_json/:id' => :edit_json, as: :get_existing_report_json
    get 'reports/new' => :new, as: :new_report #renders the view for creating one
    get 'reports/new_json' => :new_json, as: :get_new_report_json
    put 'reports/update/:id' => :update, as: :update_report
    post 'reports/create' => :create, as: :create_report
    delete 'reports/delete/:id' => :destroy, as: :delete_report
  end
  controller :report_templates do
    get 'report_templates' => :index
    get 'report_templates/edit/:id' => :edit, as: :edit_report_template #renders the view for editing one
    get 'report_templates/edit_json/:id' => :edit_json, as: :get_existing_report_template_json
    get 'report_templates/new' => :new, as: :new_report_template #renders the view for creating one
    get 'report_templates/new_json' => :new_json, as: :get_new_report_template_json
    put 'report_templates/update/:id' => :update, as: :update_report_template
    post 'report_templates/create' => :create, as: :create_report_template
    delete 'report_templates/delete/:id' => :destroy, as: :delete_report_template
  end
  controller :snippets do
    get 'snippets' => :index
    delete 'snippets/:id' => :destroy
    put 'snippets/:id' => :update
    post 'snippets' => :create
  end
  controller :settings do
    get 'settings' => :index
    put 'settings/:id' => :update, as: :update_settings
  end
  controller :export do
    get 'export/:type/:format/' => :export, as: :export
  end
  controller :image_upload do
    post '/upload' => :create
  end
  controller :user_tags do
    get '/user_tags/:type' => :index, as: :user_tags
  end
end
