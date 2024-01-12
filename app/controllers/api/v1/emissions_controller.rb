# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::EmissionsController < Api::V1::ApplicationController
    account_load_and_authorize_resource :emission, through: :team, through_association: :emissions

    # GET /api/v1/teams/:team_id/emissions
    def index
    end

    # GET /api/v1/emissions/:id
    def show
    end

    # POST /api/v1/teams/:team_id/emissions
    def create
      if @emission.save
        render :show, status: :created, location: [:api, :v1, @emission]
      else
        render json: @emission.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/emissions/:id
    def update
      if @emission.update(emission_params)
        render :show
      else
        render json: @emission.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/emissions/:id
    def destroy
      @emission.destroy
    end

    private

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def emission_params
        strong_params = params.require(:emission).permit(
          *permitted_fields,
          :source_type,
          :source_reference,
          :emission_type,
          :effective_date,
          :location,
          :region,
          :validated,
          :notes,
          # 🚅 super scaffolding will insert new fields above this line.
          *permitted_arrays,
          # 🚅 super scaffolding will insert new arrays above this line.
        )

        process_params(strong_params)

        strong_params
      end
    end

    include StrongParameters
  end
else
  class Api::V1::EmissionsController
  end
end
