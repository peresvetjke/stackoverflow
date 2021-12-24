class SearchController < ApplicationController
  authorize_resource class: false

  def index
  end

  def search
    @type, @query = params[:type], params[:query]

    @result = if @type == "All"
      ThinkingSphinx.search @query
    else
      type_klass.search @query
    end
  end

  private

  def search_params
    params.require(:search).permit(:type, :query)
  end

  def type_klass
    Object.const_get(@type.capitalize)
  end
end