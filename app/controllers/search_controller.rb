class SearchController < ApplicationController
  authorize_resource class: false

  def index
    @type, @query = params[:type], params[:query]

    if @query
      @result = @type == "All" ? ThinkingSphinx.search(@query) : type_klass.search(@query)
      @result = Kaminari.paginate_array(@result).page(params[:page] || 1).per(10)
    end
  end

  private

  def search_params
    params.require(:search).permit(:type, :query, :page)
  end

  def type_klass
    Object.const_get(@type.capitalize)
  end
end