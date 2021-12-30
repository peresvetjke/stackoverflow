class SearchController < ApplicationController
  authorize_resource class: false

  def index
    @type, @query = params[:type], params[:query]

    if @query
      @result = @type == "All" ? ThinkingSphinx.search(@query) : type_klass.search(@query)
      @result = Kaminari.paginate_array(@result).page(params[:page] || 1).per(5)

      results = @result.group_by(&:class)
      serialized = serialize(results[Question], Search::QuestionsSerializer).
          merge(serialize(results[Answer], Search::AnswersSerializer)).
          merge(serialize(results[Comment], Search::CommentsSerializer)).
          merge(serialize(results[User], Search::UsersSerializer))
    end

    respond_to do |format|
      format.html { }
      format.json { { "results" => serialized, "meta" => pagination_dict(@result) } }
  end

  private

  def search_params
    params.require(:search).permit(:type, :query, :page)
  end

  def type_klass
    Object.const_get(@type.capitalize)
  end

  # https://github.com/rails-api/active_model_serializers/blob/v0.10.6/docs/howto/add_pagination_links.md
  def pagination_dict(collection)
    {
      current_page: collection.current_page,
      next_page: collection.next_page,
      prev_page: collection.prev_page,
      total_pages: collection.total_pages,
      total_count: collection.total_count
    }
  end

  def serialize(collection, serializer, adapter = :json)
    collection.nil? ? {} : ActiveModelSerializers::SerializableResource.new(
      collection,
      each_serializer: serializer,
      adapter: adapter
    ).as_json
  end
end
