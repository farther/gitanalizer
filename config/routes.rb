Rails.application.routes.draw do
  namespace :api do
    get 'weekly_statistic', to: 'statistic#weekly_statistic', as: :weekly_statistic
    get 'daily_statistic', to: 'statistic#daily_statistic', as: :daily_statistic
  end
end
