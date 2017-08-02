class DatasetsController < ApplicationController
  include DatasetsHelper
  def show
    @dataset = current_dataset
    impressionist(@dataset) # Record that this dataset has been looked at
  end

  private

  def current_dataset
    Dataset.get({id: params[:id]})._source
  end
end
