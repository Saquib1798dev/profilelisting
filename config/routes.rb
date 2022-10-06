Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      resources :user_details do 
        post 'generate_otp', on: :member
        post 'verify_otp', on: :member
        patch 'change_password', on: :member
      end
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
