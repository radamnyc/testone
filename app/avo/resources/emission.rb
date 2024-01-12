class Avo::Resources::Emission < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :team, as: :belongs_to
    field :source_type, as: :text
    field :source_reference, as: :text
    field :emission_type, as: :text
    field :effective_date, as: :date
    field :location, as: :text
    field :region, as: :text
    field :validated, as: :boolean
    field :notes, as: :textarea
  end
end
