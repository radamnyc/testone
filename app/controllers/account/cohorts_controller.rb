class Account::CohortsController < Account::ApplicationController
  account_load_and_authorize_resource :cohort, through: :team, through_association: :cohorts

  # GET /account/teams/:team_id/cohorts
  # GET /account/teams/:team_id/cohorts.json
  def index
    delegate_json_to_api
  end

  # GET /account/cohorts/:id
  # GET /account/cohorts/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/teams/:team_id/cohorts/new
  def new
  end

  # GET /account/cohorts/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/cohorts
  # POST /account/teams/:team_id/cohorts.json
  def create
    respond_to do |format|
      if @cohort.save
        format.html { redirect_to [:account, @cohort], notice: I18n.t("cohorts.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @cohort] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @cohort.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/cohorts/:id
  # PATCH/PUT /account/cohorts/:id.json
  def update
    respond_to do |format|
      if @cohort.update(cohort_params)
        format.html { redirect_to [:account, @cohort], notice: I18n.t("cohorts.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @cohort] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @cohort.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/cohorts/:id
  # DELETE /account/cohorts/:id.json
  def destroy
    @cohort.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :cohorts], notice: I18n.t("cohorts.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  if defined?(Api::V1::ApplicationController)
    include strong_parameters_from_api
  end

  def process_params(strong_params)
    assign_date(strong_params, :closing_date)
    # 🚅 super scaffolding will insert processing for new fields above this line.
  end
end
