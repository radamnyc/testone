# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::DataFilesController < Api::V1::ApplicationController
    account_load_and_authorize_resource :data_file, through: :team, through_association: :data_files

    # GET /api/v1/teams/:team_id/data_files
    def index
    end

    # GET /api/v1/data_files/:id
    def show
    end

    # POST /api/v1/teams/:team_id/data_files
    def create
      if @data_file.save
        render :show, status: :created, location: [:api, :v1, @data_file]
      else
        render json: @data_file.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/data_files/:id
    def update
      if @data_file.update(data_file_params)
        render :show
      else
        render json: @data_file.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/data_files/:id
    def destroy
      @data_file.destroy
    end

    private

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def data_file_params
        strong_params = params.require(:data_file).permit(
          *permitted_fields,
          :description,
          :type,
          :relevant_date,
          :file,
          :file_removal,
          :valid,
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
  class Api::V1::DataFilesController
  end
end
