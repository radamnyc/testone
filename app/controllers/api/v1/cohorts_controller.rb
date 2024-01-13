# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::CohortsController < Api::V1::ApplicationController
    account_load_and_authorize_resource :cohort, through: :team, through_association: :cohorts

    # GET /api/v1/teams/:team_id/cohorts
    def index
    end

    # GET /api/v1/cohorts/:id
    def show
    end

    # POST /api/v1/teams/:team_id/cohorts
    def create
      if @cohort.save
        render :show, status: :created, location: [:api, :v1, @cohort]
      else
        render json: @cohort.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/cohorts/:id
    def update
      if @cohort.update(cohort_params)
        render :show
      else
        render json: @cohort.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/cohorts/:id
    def destroy
      @cohort.destroy
    end

    private

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def cohort_params
        strong_params = params.require(:cohort).permit(
          *permitted_fields,
          :closing_date,
          :energy_type,
          :amount,
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
  class Api::V1::CohortsController
  end
end
