require "controllers/api/v1/test"

class Api::V1::DataFilesControllerTest < Api::Test
def setup
  # See `test/controllers/api/test.rb` for common set up for API tests.
  super

  @data_file = build(:data_file, team: @team)
  @other_data_files = create_list(:data_file, 3)

  @another_data_file = create(:data_file, team: @team)

  @data_file.file = Rack::Test::UploadedFile.new("test/support/foo.txt")
  @another_data_file.file = Rack::Test::UploadedFile.new("test/support/foo.txt")
  # 🚅 super scaffolding will insert file-related logic above this line.
  @data_file.save
  @another_data_file.save

  @original_hide_things = ENV["HIDE_THINGS"]
  ENV["HIDE_THINGS"] = "false"
  Rails.application.reload_routes!
end

def teardown
  super
  ENV["HIDE_THINGS"] = @original_hide_things
  Rails.application.reload_routes!
end

# This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
# data we were previously providing to users _will_ break the test suite.
def assert_proper_object_serialization(data_file_data)
  # Fetch the data_file in question and prepare to compare it's attributes.
  data_file = DataFile.find(data_file_data["id"])

  assert_equal_or_nil data_file_data['description'], data_file.description
  assert_equal_or_nil data_file_data['type'], data_file.type
  assert_equal_or_nil Date.parse(data_file_data['relevant_date']), data_file.relevant_date
  assert_equal data_file_data['file'], rails_blob_path(@data_file.file) unless controller.action_name == 'create'
  assert_equal_or_nil data_file_data['valid'], data_file.valid
  assert_equal_or_nil data_file_data['notes'], data_file.notes
  # 🚅 super scaffolding will insert new fields above this line.

  assert_equal data_file_data["team_id"], data_file.team_id
end

test "index" do
  # Fetch and ensure nothing is seriously broken.
  get "/api/v1/teams/#{@team.id}/data_files", params: {access_token: access_token}
  assert_response :success

  # Make sure it's returning our resources.
  data_file_ids_returned = response.parsed_body.map { |data_file| data_file["id"] }
  assert_includes(data_file_ids_returned, @data_file.id)

  # But not returning other people's resources.
  assert_not_includes(data_file_ids_returned, @other_data_files[0].id)

  # And that the object structure is correct.
  assert_proper_object_serialization response.parsed_body.first
end

test "show" do
  # Fetch and ensure nothing is seriously broken.
  get "/api/v1/data_files/#{@data_file.id}", params: {access_token: access_token}
  assert_response :success

  # Ensure all the required data is returned properly.
  assert_proper_object_serialization response.parsed_body

  # Also ensure we can't do that same action as another user.
  get "/api/v1/data_files/#{@data_file.id}", params: {access_token: another_access_token}
  assert_response :not_found
end

test "create" do
  # Use the serializer to generate a payload, but strip some attributes out.
  params = {access_token: access_token}
  data_file_data = JSON.parse(build(:data_file, team: nil).api_attributes.to_json)
  data_file_data.except!("id", "team_id", "created_at", "updated_at")
  params[:data_file] = data_file_data

  post "/api/v1/teams/#{@team.id}/data_files", params: params
  assert_response :success

  # # Ensure all the required data is returned properly.
  assert_proper_object_serialization response.parsed_body

  # Also ensure we can't do that same action as another user.
  post "/api/v1/teams/#{@team.id}/data_files",
    params: params.merge({access_token: another_access_token})
  assert_response :not_found
end

test "update" do
  # Post an attribute update ensure nothing is seriously broken.
  put "/api/v1/data_files/#{@data_file.id}", params: {
    access_token: access_token,
    data_file: {
      description: 'Alternative String Value',
      notes: 'Alternative String Value',
      # 🚅 super scaffolding will also insert new fields above this line.
    }
  }

  assert_response :success

  # Ensure all the required data is returned properly.
  assert_proper_object_serialization response.parsed_body

  # But we have to manually assert the value was properly updated.
  @data_file.reload
  assert_equal @data_file.description, 'Alternative String Value'
  assert_equal @data_file.notes, 'Alternative String Value'
  # 🚅 super scaffolding will additionally insert new fields above this line.

  # Also ensure we can't do that same action as another user.
  put "/api/v1/data_files/#{@data_file.id}", params: {access_token: another_access_token}
  assert_response :not_found
end

test "destroy" do
  # Delete and ensure it actually went away.
  assert_difference("DataFile.count", -1) do
    delete "/api/v1/data_files/#{@data_file.id}", params: {access_token: access_token}
    assert_response :success
  end

  # Also ensure we can't do that same action as another user.
  delete "/api/v1/data_files/#{@another_data_file.id}", params: {access_token: another_access_token}
  assert_response :not_found
end
end
