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
end
