require "controllers/api/v1/test"

class Api::V1::CohortsControllerTest < Api::Test
def setup
  # See `test/controllers/api/test.rb` for common set up for API tests.
  super

  @cohort = build(:cohort, team: @team)
  @other_cohorts = create_list(:cohort, 3)

  @another_cohort = create(:cohort, team: @team)

  # 🚅 super scaffolding will insert file-related logic above this line.
  @cohort.save
  @another_cohort.save

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
def assert_proper_object_serialization(cohort_data)
  # Fetch the cohort in question and prepare to compare it's attributes.
  cohort = Cohort.find(cohort_data["id"])

  assert_equal_or_nil Date.parse(cohort_data['closing_date']), cohort.closing_date
  assert_equal_or_nil cohort_data['energy_type'], cohort.energy_type
  assert_equal_or_nil cohort_data['amount'], cohort.amount
  # 🚅 super scaffolding will insert new fields above this line.

  assert_equal cohort_data["team_id"], cohort.team_id
end

test "index" do
  # Fetch and ensure nothing is seriously broken.
  get "/api/v1/teams/#{@team.id}/cohorts", params: {access_token: access_token}
  assert_response :success

  # Make sure it's returning our resources.
  cohort_ids_returned = response.parsed_body.map { |cohort| cohort["id"] }
  assert_includes(cohort_ids_returned, @cohort.id)

  # But not returning other people's resources.
  assert_not_includes(cohort_ids_returned, @other_cohorts[0].id)

  # And that the object structure is correct.
  assert_proper_object_serialization response.parsed_body.first
end

test "show" do
  # Fetch and ensure nothing is seriously broken.
  get "/api/v1/cohorts/#{@cohort.id}", params: {access_token: access_token}
  assert_response :success

  # Ensure all the required data is returned properly.
  assert_proper_object_serialization response.parsed_body

  # Also ensure we can't do that same action as another user.
  get "/api/v1/cohorts/#{@cohort.id}", params: {access_token: another_access_token}
  assert_response :not_found
end

test "create" do
  # Use the serializer to generate a payload, but strip some attributes out.
  params = {access_token: access_token}
  cohort_data = JSON.parse(build(:cohort, team: nil).api_attributes.to_json)
  cohort_data.except!("id", "team_id", "created_at", "updated_at")
  params[:cohort] = cohort_data

  post "/api/v1/teams/#{@team.id}/cohorts", params: params
  assert_response :success

  # # Ensure all the required data is returned properly.
  assert_proper_object_serialization response.parsed_body

  # Also ensure we can't do that same action as another user.
  post "/api/v1/teams/#{@team.id}/cohorts",
    params: params.merge({access_token: another_access_token})
  assert_response :not_found
end

test "update" do
  # Post an attribute update ensure nothing is seriously broken.
  put "/api/v1/cohorts/#{@cohort.id}", params: {
    access_token: access_token,
    cohort: {
      # 🚅 super scaffolding will also insert new fields above this line.
    }
  }

  assert_response :success

  # Ensure all the required data is returned properly.
  assert_proper_object_serialization response.parsed_body

  # But we have to manually assert the value was properly updated.
  @cohort.reload
  # 🚅 super scaffolding will additionally insert new fields above this line.

  # Also ensure we can't do that same action as another user.
  put "/api/v1/cohorts/#{@cohort.id}", params: {access_token: another_access_token}
  assert_response :not_found
end

test "destroy" do
  # Delete and ensure it actually went away.
  assert_difference("Cohort.count", -1) do
    delete "/api/v1/cohorts/#{@cohort.id}", params: {access_token: access_token}
    assert_response :success
  end

  # Also ensure we can't do that same action as another user.
  delete "/api/v1/cohorts/#{@another_cohort.id}", params: {access_token: another_access_token}
  assert_response :not_found
end
end
