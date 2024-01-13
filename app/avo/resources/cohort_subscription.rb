class Avo::Resources::CohortSubscription < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :project, as: :belongs_to
    field :cohort, as: :belongs_to
    field :state_of_interest, as: :text
    field :amount, as: :number
  end
end
