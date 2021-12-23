class SearchController < ApplicationController
  skip_authorization_check

  # respond_to :html, :js

  def index
  end

  def search
    @type, @text = params[:type], params[:text]

    @result = if @type == "All"
      ThinkingSphinx.search @text
    else
      type_klass.search @text
    end
  end

  private

  def search_params
    params.require(:search).permit(:type, :text)
  end

  def type_klass
    Object.const_get(@type.capitalize)
  end
end