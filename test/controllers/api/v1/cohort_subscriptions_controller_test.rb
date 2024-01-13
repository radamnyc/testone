require "controllers/api/v1/test"

class Api::V1::CohortSubscriptionsControllerTest < Api::Test
def setup
  # See `test/controllers/api/test.rb` for common set up for API tests.
  super

  @project = create(:project, team: @team)
  @cohort_subscription = build(:cohort_subscription, project: @project)
  @other_cohort_subscriptions = create_list(:cohort_subscription, 3)

  @another_cohort_subscription = create(:cohort_subscription, project: @project)

  # 🚅 super scaffolding will insert file-related logic above this line.
  @cohort_subscription.save
  @another_cohort_subscription.save

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
def assert_proper_object_serialization(cohort_subscription_data)
  # Fetch the cohort_subscription in question and prepare to compare it's attributes.
  cohort_subscription = CohortSubscription.find(cohort_subscription_data["id"])

  assert_equal_or_nil cohort_subscription_data['cohort_id'], cohort_subscription.cohort_id
  assert_equal_or_nil cohort_subscription_data['state_of_interest'], cohort_subscription.state_of_interest
  assert_equal_or_nil cohort_subscription_data['amount'], cohort_subscription.amount
  # 🚅 super scaffolding will insert new fields above this line.

  assert_equal cohort_subscription_data["project_id"], cohort_subscription.project_id
end

test "index" do
  # Fetch and ensure nothing is seriously broken.
  get "/api/v1/projects/#{@project.id}/cohort_subscriptions", params: {access_token: access_token}
  assert_response :success

  # Make sure it's returning our resources.
  cohort_subscription_ids_returned = response.parsed_body.map { |cohort_subscription| cohort_subscription["id"] }
  assert_includes(cohort_subscription_ids_returned, @cohort_subscription.id)

  # But not returning other people's resources.
  assert_not_includes(cohort_subscription_ids_returned, @other_cohort_subscriptions[0].id)

  # And that the object structure is correct.
  assert_proper_object_serialization response.parsed_body.first
end

test "show" do
  # Fetch and ensure nothing is seriously broken.
  get "/api/v1/cohort_subscriptions/#{@cohort_subscription.id}", params: {access_token: access_token}
  assert_response :success

  # Ensure all the required data is returned properly.
  assert_proper_object_serialization response.parsed_body

  # Also ensure we can't do that same action as another user.
  get "/api/v1/cohort_subscriptions/#{@cohort_subscription.id}", params: {access_token: another_access_token}
  assert_response :not_found
end

test "create" do
  # Use the serializer to generate a payload, but strip some attributes out.
  params = {access_token: access_token}
  cohort_subscription_data = JSON.parse(build(:cohort_subscription, project: nil).api_attributes.to_json)
  cohort_subscription_data.except!("id", "project_id", "created_at", "updated_at")
  params[:cohort_subscription] = cohort_subscription_data

  post "/api/v1/projects/#{@project.id}/cohort_subscriptions", params: params
  assert_response :success

  # # Ensure all the required data is returned properly.
  assert_proper_object_serialization response.parsed_body

  # Also ensure we can't do that same action as another user.
  post "/api/v1/projects/#{@project.id}/cohort_subscriptions",
    params: params.merge({access_token: another_access_token})
  assert_response :not_found
end

test "update" do
  # Post an attribute update ensure nothing is seriously broken.
  put "/api/v1/cohort_subscriptions/#{@cohort_subscription.id}", params: {
    access_token: access_token,
    cohort_subscription: {
      # 🚅 super scaffolding will also insert new fields above this line.
    }
  }

  assert_response :success

  # Ensure all the required data is returned properly.
  assert_proper_object_serialization response.parsed_body

  # But we have to manually assert the value was properly updated.
  @cohort_subscription.reload
  # 🚅 super scaffolding will additionally insert new fields above this line.

  # Also ensure we can't do that same action as another user.
  put "/api/v1/cohort_subscriptions/#{@cohort_subscription.id}", params: {access_token: another_access_token}
  assert_response :not_found
end

test "destroy" do
  # Delete and ensure it actually went away.
  assert_difference("CohortSubscription.count", -1) do
    delete "/api/v1/cohort_subscriptions/#{@cohort_subscription.id}", params: {access_token: access_token}
    assert_response :success
  end

  # Also ensure we can't do that same action as another user.
  delete "/api/v1/cohort_subscriptions/#{@another_cohort_subscription.id}", params: {access_token: another_access_token}
  assert_response :not_found
end
end
