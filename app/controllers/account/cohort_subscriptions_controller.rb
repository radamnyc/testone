class Account::CohortSubscriptionsController < Account::ApplicationController
  account_load_and_authorize_resource :cohort_subscription, through: :project, through_association: :cohort_subscriptions

  # GET /account/projects/:project_id/cohort_subscriptions
  # GET /account/projects/:project_id/cohort_subscriptions.json
  def index
    delegate_json_to_api
  end

  # GET /account/cohort_subscriptions/:id
  # GET /account/cohort_subscriptions/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/projects/:project_id/cohort_subscriptions/new
  def new
  end

  # GET /account/cohort_subscriptions/:id/edit
  def edit
  end

  # POST /account/projects/:project_id/cohort_subscriptions
  # POST /account/projects/:project_id/cohort_subscriptions.json
  def create
    respond_to do |format|
      if @cohort_subscription.save
        format.html { redirect_to [:account, @cohort_subscription], notice: I18n.t("cohort_subscriptions.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @cohort_subscription] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @cohort_subscription.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/cohort_subscriptions/:id
  # PATCH/PUT /account/cohort_subscriptions/:id.json
  def update
    respond_to do |format|
      if @cohort_subscription.update(cohort_subscription_params)
        format.html { redirect_to [:account, @cohort_subscription], notice: I18n.t("cohort_subscriptions.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @cohort_subscription] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @cohort_subscription.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/cohort_subscriptions/:id
  # DELETE /account/cohort_subscriptions/:id.json
  def destroy
    @cohort_subscription.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @project, :cohort_subscriptions], notice: I18n.t("cohort_subscriptions.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  if defined?(Api::V1::ApplicationController)
    include strong_parameters_from_api
  end

  def process_params(strong_params)
    # 🚅 super scaffolding will insert processing for new fields above this line.
  end
end
