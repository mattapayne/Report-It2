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
    get 'edit_report' => :edit
    get 'new_report' => :new
    delete 'reports/:id' => :destroy
    put 'reports/:id' => :update
    post 'reports' => :create
  end
  controller :report_templates do
    get 'report_templates' => :index
    get 'edit_report_template' => :edit
    get 'new_report_template' => :new
    delete 'report_templates/:id' => :destroy
    put 'report_templates/:id' => :update
    post 'report_templates' => :create
  end
  controller :organizations do
    get 'organizations' => :index
    delete 'organizations/:id' => :destroy
    put 'organizations/:id' => :update
    post 'organizations' => :create
  end
  controller :snippets do
    get 'snippets' => :index
    delete 'snippets/:id' => :destroy
    put 'snippets/:id' => :update
    post 'snippets' => :create
  end
  controller :settings do
    get 'settings' => :index
    put 'settings/:id' => :update
  end
  controller :export do
    get 'export/:type/:format/:id' => :export, as: :export
  end
end
