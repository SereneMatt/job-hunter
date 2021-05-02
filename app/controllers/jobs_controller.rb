class JobsController < ApplicationController
  def index
  end

  def search
    response = Faraday.get("https://jobs.github.com/positions.json?search=#{params[:text]}&location=munich")
    # TODO: Process results before rendering in view
    @search_results = JSON.parse(response.body)
    @time = ApplicationController.helpers.time_ago_in_words(Time.current + 7.days)

    render :index
  end
end
