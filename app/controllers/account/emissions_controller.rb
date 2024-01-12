class Account::EmissionsController < Account::ApplicationController
  account_load_and_authorize_resource :emission, through: :team, through_association: :emissions

  # GET /account/teams/:team_id/emissions
  # GET /account/teams/:team_id/emissions.json
  def index
    delegate_json_to_api
  end

  # GET /account/emissions/:id
  # GET /account/emissions/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/teams/:team_id/emissions/new
  def new
  end

  # GET /account/emissions/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/emissions
  # POST /account/teams/:team_id/emissions.json
  def create
    respond_to do |format|
      if @emission.save
        format.html { redirect_to [:account, @emission], notice: I18n.t("emissions.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @emission] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @emission.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/emissions/:id
  # PATCH/PUT /account/emissions/:id.json
  def update
    respond_to do |format|
      if @emission.update(emission_params)
        format.html { redirect_to [:account, @emission], notice: I18n.t("emissions.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @emission] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @emission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/emissions/:id
  # DELETE /account/emissions/:id.json
  def destroy
    @emission.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :emissions], notice: I18n.t("emissions.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  if defined?(Api::V1::ApplicationController)
    include strong_parameters_from_api
  end

  def process_params(strong_params)
    assign_date(strong_params, :effective_date)
    # 🚅 super scaffolding will insert processing for new fields above this line.
  end
end
