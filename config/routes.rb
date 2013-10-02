ReportIt::Application.routes.draw do
  root to: "home#index"
  
  namespace :api, defaults: { format: 'json'} do
    namespace :v1 do
      controller :user_tags do
        get '/user_tags/:type' => :index, as: :get_user_tags
      end
      controller :snippets do
        get 'snippets' => :index, as: :get_snippets
        delete 'snippets/:id' => :destroy, as: :destroy_snippet
        put 'snippets/:id' => :update, as: :update_snippet
        post 'snippets' => :create, as: :create_snippet
      end
      controller :settings do
        get 'settings' => :index, as: :get_settings
        put 'settings/:id' => :update, as: :update_settings
      end
      controller :reports do
        get 'reports' => :index, as: :get_reports
        get 'reports/new/:type' => :new, as: :new_report
        get 'reports/edit/:id' => :edit, as: :edit_report
        put 'reports/:id' => :update, as: :update_report
        post 'reports' => :create, as: :create_report
        post 'reports/copy/:id' => :copy, as: :copy_report
        delete 'reports/:id' => :destroy, as: :destroy_report
      end
      controller :shares do
        get '/shares/:id' => :index, as: :get_shares
        put '/shares/:id' => :update, as: :update_share
      end
      controller :image_upload do
        post '/upload' => :create, as: :image_upload
      end
    end
  end
  
  controller :home do
    get 'about' => :about
    get 'contact' => :contact, as: :message
    post 'message' => :create, as: :create_message
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
    post 'register' => :create, as: :create_registration
  end
  controller :account_validation do
    get 'validate_account/:token' => :new, as: 'validate_account'
  end
  controller :forgot_password do
    get 'forgot_password' => :new
    post 'forgot_password' => :create, as: :create_forgot_password_request
    get 'password_reset/:token' => :reset, as: 'password_reset'
  end
  controller :my_account do
    get 'my_account' => :index  
  end
  controller :reports do
    get 'reports/edit/:id' => :edit, as: :edit_report
    get 'reports/new/:type' => :new, as: :new_report
  end
  controller :export do
    get 'export/:type/:format/' => :export, as: :export
  end
  controller :image_upload do
    post '/upload' => :create
  end
end
