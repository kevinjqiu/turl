Rails.application.routes.draw do
  post 'links', to: 'links#create'
  get  '*path', to: 'links#follow'
end
