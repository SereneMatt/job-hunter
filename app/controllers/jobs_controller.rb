class JobsController < ApplicationController
  def index
  end

  def search
    response = Faraday.get("https://jobs.github.com/positions.json?search=#{params[:text]}&location=munich")

    @search_results = process_results JSON.parse(response.body)

    render :index
  end

  def toggle_vote
    job_id = params[:job_id]
    user = params[:user]
    status = params[:status]

    vote = Vote.find_by(user_id: user, job_id: job_id)

    if vote.blank?
      Vote.create(user_id: user, job_id: job_id, status: status)
    else
      vote.update(status: status)
    end

    # TODO: Redirect user to jobs and retain the search results
    # render :index
  end

  private
    def process_results response_body
      search_results = []
    
      response_body.map {|search_result|
        result = Hash.new
        result = search_result.select{|key| ["id", "company_logo", "title", "company"].include?(key) }
        result["posted_at"] = ApplicationController.helpers.time_ago_in_words(search_result["created_at"])
        votes = Vote.where(job_id: result["id"])
        result["upvote_count"] = (votes.filter {|vote| vote.status == true}).count
        result["downvote_count"] = (votes.filter {|vote| vote.status == false}).count
  
        search_results.push(result)
      }

      search_results
    end

    def vote_params
      params.permit(:job_id, :user, :job_id, :status)
    end
end
