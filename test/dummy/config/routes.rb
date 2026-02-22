Rails.application.routes.draw do
  mount Lesli::Engine => "/lesli"
  devise_for :users, class_name: "Lesli::User"
end
