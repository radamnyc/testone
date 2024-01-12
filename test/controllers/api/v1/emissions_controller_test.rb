require "controllers/api/v1/test"

class Api::V1::EmissionsControllerTest < Api::Test
def setup
  # See `test/controllers/api/test.rb` for common set up for API tests.
  super

  @emission = build(:emission, team: @team)
  @other_emissions = create_list(:emission, 3)

  @another_emission = create(:emission, team: @team)

  # 🚅 super scaffolding will insert file-related logic above this line.
  @emission.save
  @another_emission.save

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
def assert_proper_object_serialization(emission_data)
  # Fetch the emission in question and prepare to compare it's attributes.
  emission = Emission.find(emission_data["id"])

  assert_equal_or_nil emission_data['source_type'], emission.source_type
  assert_equal_or_nil emission_data['source_reference'], emission.source_reference
  assert_equal_or_nil emission_data['emission_type'], emission.emission_type
  assert_equal_or_nil Date.parse(emission_data['effective_date']), emission.effective_date
  assert_equal_or_nil emission_data['location'], emission.location
  assert_equal_or_nil emission_data['region'], emission.region
  assert_equal_or_nil emission_data['validated'], emission.validated
  assert_equal_or_nil emission_data['notes'], emission.notes
  # 🚅 super scaffolding will insert new fields above this line.

  assert_equal emission_data["team_id"], emission.team_id
end

test "index" do
  # Fetch and ensure nothing is seriously broken.
  get "/api/v1/teams/#{@team.id}/emissions", params: {access_token: access_token}
  assert_response :success

  # Make sure it's returning our resources.
  emission_ids_returned = response.parsed_body.map { |emission| emission["id"] }
  assert_includes(emission_ids_returned, @emission.id)

  # But not returning other people's resources.
  assert_not_includes(emission_ids_returned, @other_emissions[0].id)

  # And that the object structure is correct.
  assert_proper_object_serialization response.parsed_body.first
end

test "show" do
  # Fetch and ensure nothing is seriously broken.
  get "/api/v1/emissions/#{@emission.id}", params: {access_token: access_token}
  assert_response :success

  # Ensure all the required data is returned properly.
  assert_proper_object_serialization response.parsed_body

  # Also ensure we can't do that same action as another user.
  get "/api/v1/emissions/#{@emission.id}", params: {access_token: another_access_token}
  assert_response :not_found
end

test "create" do
  # Use the serializer to generate a payload, but strip some attributes out.
  params = {access_token: access_token}
  emission_data = JSON.parse(build(:emission, team: nil).api_attributes.to_json)
  emission_data.except!("id", "team_id", "created_at", "updated_at")
  params[:emission] = emission_data

  post "/api/v1/teams/#{@team.id}/emissions", params: params
  assert_response :success

  # # Ensure all the required data is returned properly.
  assert_proper_object_serialization response.parsed_body

  # Also ensure we can't do that same action as another user.
  post "/api/v1/teams/#{@team.id}/emissions",
    params: params.merge({access_token: another_access_token})
  assert_response :not_found
end

test "update" do
  # Post an attribute update ensure nothing is seriously broken.
  put "/api/v1/emissions/#{@emission.id}", params: {
    access_token: access_token,
    emission: {
      source_reference: 'Alternative String Value',
      location: 'Alternative String Value',
      region: 'Alternative String Value',
      notes: 'Alternative String Value',
      # 🚅 super scaffolding will also insert new fields above this line.
    }
  }

  assert_response :success

  # Ensure all the required data is returned properly.
  assert_proper_object_serialization response.parsed_body

  # But we have to manually assert the value was properly updated.
  @emission.reload
  assert_equal @emission.source_reference, 'Alternative String Value'
  assert_equal @emission.location, 'Alternative String Value'
  assert_equal @emission.region, 'Alternative String Value'
  assert_equal @emission.notes, 'Alternative String Value'
  # 🚅 super scaffolding will additionally insert new fields above this line.

  # Also ensure we can't do that same action as another user.
  put "/api/v1/emissions/#{@emission.id}", params: {access_token: another_access_token}
  assert_response :not_found
end

test "destroy" do
  # Delete and ensure it actually went away.
  assert_difference("Emission.count", -1) do
    delete "/api/v1/emissions/#{@emission.id}", params: {access_token: access_token}
    assert_response :success
  end

  # Also ensure we can't do that same action as another user.
  delete "/api/v1/emissions/#{@another_emission.id}", params: {access_token: another_access_token}
  assert_response :not_found
end
end
