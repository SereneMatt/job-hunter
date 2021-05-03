class JobsController < ApplicationController
  def index
  end

  def search
    response = Faraday.get("https://jobs.github.com/positions.json?search=#{params[:text]}&location=munich")

    @search_results = process_results JSON.parse(response.body)

    render :index
  end

  private
    def process_results response_body
      search_results = []
    
      response_body.map {|search_result|
        result = Hash.new
        result = search_result.select{|key| ["company_logo", "title", "company"].include?(key) }
        result["posted_at"] = ApplicationController.helpers.time_ago_in_words(search_result["created_at"])
  
        search_results.push(result)
      }

      search_results
    end
end
