# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::CohortSubscriptionsController < Api::V1::ApplicationController
    account_load_and_authorize_resource :cohort_subscription, through: :project, through_association: :cohort_subscriptions

    # GET /api/v1/projects/:project_id/cohort_subscriptions
    def index
    end

    # GET /api/v1/cohort_subscriptions/:id
    def show
    end

    # POST /api/v1/projects/:project_id/cohort_subscriptions
    def create
      if @cohort_subscription.save
        render :show, status: :created, location: [:api, :v1, @cohort_subscription]
      else
        render json: @cohort_subscription.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/cohort_subscriptions/:id
    def update
      if @cohort_subscription.update(cohort_subscription_params)
        render :show
      else
        render json: @cohort_subscription.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/cohort_subscriptions/:id
    def destroy
      @cohort_subscription.destroy
    end

    private

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def cohort_subscription_params
        strong_params = params.require(:cohort_subscription).permit(
          *permitted_fields,
          :cohort_id,
          :state_of_interest,
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
  class Api::V1::CohortSubscriptionsController
  end
end
