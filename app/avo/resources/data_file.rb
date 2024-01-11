class Avo::Resources::DataFile < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :team, as: :belongs_to
    field :description, as: :textarea
    field :type, as: :text
    field :relevant_date, as: :date
    field :file, as: :text
    field :valid, as: :boolean
    field :notes, as: :textarea
  end
end
