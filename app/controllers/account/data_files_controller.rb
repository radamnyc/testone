class Account::DataFilesController < Account::ApplicationController
  account_load_and_authorize_resource :data_file, through: :team, through_association: :data_files

  # GET /account/teams/:team_id/data_files
  # GET /account/teams/:team_id/data_files.json
  def index
    delegate_json_to_api
  end

  # GET /account/data_files/:id
  # GET /account/data_files/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/teams/:team_id/data_files/new
  def new
  end

  # GET /account/data_files/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/data_files
  # POST /account/teams/:team_id/data_files.json
  def create
    respond_to do |format|
      if @data_file.save
        format.html { redirect_to [:account, @data_file], notice: I18n.t("data_files.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @data_file] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @data_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/data_files/:id
  # PATCH/PUT /account/data_files/:id.json
  def update
    respond_to do |format|
      if @data_file.update(data_file_params)
        format.html { redirect_to [:account, @data_file], notice: I18n.t("data_files.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @data_file] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @data_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/data_files/:id
  # DELETE /account/data_files/:id.json
  def destroy
    @data_file.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :data_files], notice: I18n.t("data_files.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  if defined?(Api::V1::ApplicationController)
    include strong_parameters_from_api
  end

  def process_params(strong_params)
    assign_date(strong_params, :relevant_date)
    # 🚅 super scaffolding will insert processing for new fields above this line.
  end
end
