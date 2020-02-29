class CalculateStatistic

  attr_accessor :period, :repo, :repo_user

  def initialize(period:, repo_user:, repo:)
    @period = period
    @repo = repo
    @repo_user = repo_user
  end

  def perform
    if current_period?
      saved_data.statistic_data
    else
      renew_data
    end
  end

  private

  def current_period?
    saved_data.present? && saved_data.created_at > Time.now - 1.send(period.to_s)
  end

  def saved_data
    @saved_data ||= Statistic.last
  end

  def renew_data
    Statistic.create!(statistic_data: git_data).statistic_data
  end

  def git_data
    @git_data ||= {
      pull_request: generate_object(pull_requests_data, 12),
      reviews: generate_object(reviews_data, 3),
      comments: generate_object(comments_data, 1)
    }
  end

  def pull_requests_data
    github.pull_requests.list.body.map { |p| p.user.login }
  end

  def pull_request_count
    github.pull_requests.list.body.size
  end

  def reviews_data
    reviews_data = []
    pull_request_count.times do |number|
      reviews_data << github.pull_requests.reviews
        .list(user: repo_user, repo: repo, number: number + 1)
        .map { |c| c.user.login }
    end
    reviews_data.flatten
  end

  def comments_data
    comments_data = []
    pull_request_count.times do |number|
      comments_data << github.pull_requests.comments
        .list(user: repo_user, repo: repo, number: number + 1)
        .map { |c| c.user.login }
    end
    comments_data.flatten
  end

  def generate_object(array, points)
    object = {}
    array.each do |a|
      object[a] = object[a].to_i + points
    end
    object
  end

  def github
    @github ||= Github.new user: repo_user, repo: repo, ssl: {verify: false}
  end

end
