class Avo::Resources::ProjectDataFile < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :project, as: :belongs_to
    field :data_file, as: :belongs_to
  end
end
