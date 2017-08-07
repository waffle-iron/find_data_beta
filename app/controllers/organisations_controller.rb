class OrganisationsController < ApplicationController
  protect_from_forgery prepend: :true

  def lookup
    @search = Dataset.search(search_query)
    render json: @search
  end

  private
  def search_query
    {
      aggs: {
        organisations: {
          terms: { field:  'organisation'}
        }
      }
    }
  end

end
