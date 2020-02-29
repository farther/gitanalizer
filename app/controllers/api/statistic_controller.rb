class Api::StatisticController < ApplicationController
  require 'json'

  def weekly_statistic
    begin
      render json: CalculateStatistic.new(period: 'week',
                                          repo_user: params[:repo_user],
                                          repo: params[:repo]).perform
    rescue StandardError => e
      render json: e
    end
  end

  def daily_statistic
    begin
      render json: CalculateStatistic.new(period: 'day',
                                          repo_user: params[:repo_user],
                                          repo: params[:repo]).perform
    rescue StandardError => e
      render json: e
    end
  end
end
