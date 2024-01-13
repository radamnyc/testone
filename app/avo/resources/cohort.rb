class Avo::Resources::Cohort < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :team, as: :belongs_to
    field :closing_date, as: :date
    field :energy_type, as: :text
    field :amount, as: :number
  end
end
