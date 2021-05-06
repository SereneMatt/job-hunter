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

        vote_statistics = get_vote_statistics result["id"]
        result["upvote_count"] = vote_statistics["upvote_count"]
        result["downvote_count"] = vote_statistics["downvote_count"]
        result["voted_by"] = vote_statistics["voted_by"]
  
        search_results.push(result)
      }

      search_results
    end

    def get_vote_statistics job_id
      vote_statistics = {}

      votes = Vote.where(job_id: job_id)
      vote_statistics["upvote_count"] = (votes.filter {|vote| vote.status == true}).count
      vote_statistics["downvote_count"] = (votes.filter {|vote| vote.status == false}).count
      users = votes.map {|vote| vote.user.username}

      vote_statistics["voted_by"] = users.length > 0 ? ((users.length - 3) > 0 ? "by #{users[0...3].join(", ")} and #{users.length - 3} more users"
        : "by #{users[0...3].join(", ")}") : ""

      vote_statistics
    end

    def vote_params
      params.permit(:job_id, :user, :job_id, :status)
    end
end
