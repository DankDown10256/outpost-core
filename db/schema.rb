# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_10_30_120000) do
  create_table "activities", force: :cascade do |t|
    t.string "name"
    t.string "provider"
    t.string "webhook_link"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "secret", null: false
    t.integer "project_id", null: false
    t.index ["project_id"], name: "index_activities_on_project_id"
  end

  create_table "invitations", force: :cascade do |t|
    t.integer "organization_id", null: false
    t.integer "sender_id", null: false
    t.integer "recipient_id", null: false
    t.string "status", default: "pending", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id", "recipient_id"], name: "index_invitations_on_organization_id_and_recipient_id", unique: true
    t.index ["organization_id"], name: "index_invitations_on_organization_id"
    t.index ["recipient_id"], name: "index_invitations_on_recipient_id"
    t.index ["sender_id"], name: "index_invitations_on_sender_id"
    t.check_constraint "status IN ('pending', 'accepted', 'declined')", name: "invitations_status"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "organizations_users", id: false, force: :cascade do |t|
    t.integer "organization_id", null: false
    t.integer "user_id", null: false
    t.string "role", default: "member", null: false
    t.index ["organization_id", "user_id"], name: "index_organizations_users_on_organization_id_and_user_id", unique: true
    t.index ["organization_id"], name: "one_owner_per_organization", unique: true, where: "role = 'owner'"
    t.index ["user_id"], name: "index_organizations_users_on_user_id"
    t.check_constraint "role IN ('owner', 'admin', 'member')", name: "organization_membership_role"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "organization"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "organization_id", null: false
    t.string "repo_url"
    t.index ["organization_id"], name: "index_projects_on_organization_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "assigned_user_id"
    t.index ["assigned_user_id"], name: "index_tasks_on_assigned_user_id"
    t.index ["project_id"], name: "index_tasks_on_project_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.integer "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_teams_on_organization_id"
  end

  create_table "teams_users", id: false, force: :cascade do |t|
    t.integer "team_id", null: false
    t.integer "user_id", null: false
    t.index ["team_id", "user_id"], name: "index_teams_users_on_team_id_and_user_id", unique: true
    t.index ["user_id"], name: "index_teams_users_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "profession"
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  create_table "webhook_events", force: :cascade do |t|
    t.integer "activity_id", null: false
    t.string "delivery_id", null: false
    t.string "event", null: false
    t.string "summary", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_id", "delivery_id"], name: "index_webhook_events_on_activity_id_and_delivery_id", unique: true
    t.index ["activity_id"], name: "index_webhook_events_on_activity_id"
  end

  add_foreign_key "activities", "projects"
  add_foreign_key "invitations", "organizations"
  add_foreign_key "invitations", "users", column: "recipient_id"
  add_foreign_key "invitations", "users", column: "sender_id"
  add_foreign_key "organizations_users", "organizations"
  add_foreign_key "organizations_users", "users"
  add_foreign_key "projects", "organizations"
  add_foreign_key "sessions", "users"
  add_foreign_key "tasks", "projects"
  add_foreign_key "tasks", "users", column: "assigned_user_id"
  add_foreign_key "teams", "organizations"
  add_foreign_key "teams_users", "teams"
  add_foreign_key "teams_users", "users"
  add_foreign_key "webhook_events", "activities"
end
