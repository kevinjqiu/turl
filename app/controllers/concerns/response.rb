module Response
  def json(object, excluded_fields, status = :ok)
    render json: object.as_json.except(*excluded_fields), status: status
  end
end
