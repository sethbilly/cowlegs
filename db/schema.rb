# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20181221103445) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "animal_tag_vaccinations", force: :cascade do |t|
    t.string "type_of_vaccination"
    t.bigint "animal_tag_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "notes"
    t.index ["animal_tag_id"], name: "index_animal_tag_vaccinations_on_animal_tag_id"
    t.index ["user_id"], name: "index_animal_tag_vaccinations_on_user_id"
  end

  create_table "animal_tags", force: :cascade do |t|
    t.bigint "farmer_id"
    t.string "bid_number"
    t.string "tag_number"
    t.integer "age"
    t.string "sex"
    t.text "notes"
    t.string "breed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type_of_animal"
    t.index ["farmer_id"], name: "index_animal_tags_on_farmer_id"
  end

  create_table "campaign_messages", force: :cascade do |t|
    t.bigint "message_id"
    t.bigint "campaign_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_campaign_messages_on_campaign_id"
    t.index ["message_id"], name: "index_campaign_messages_on_message_id"
  end

  create_table "campaign_subscriptions", force: :cascade do |t|
    t.bigint "campaign_id"
    t.bigint "farmer_id"
    t.boolean "subscribed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_campaign_subscriptions_on_campaign_id"
    t.index ["farmer_id"], name: "index_campaign_subscriptions_on_farmer_id"
  end

  create_table "campaign_zones", force: :cascade do |t|
    t.bigint "zone_id"
    t.bigint "campaign_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_campaign_zones_on_campaign_id"
    t.index ["zone_id"], name: "index_campaign_zones_on_zone_id"
  end

  create_table "campaigns", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "type_of_campaign_id"
    t.string "code"
    t.date "delivery_date"
    t.date "completion_date"
    t.integer "status", default: 0
    t.string "slug"
    t.bigint "region_id"
    t.bigint "district_id"
    t.decimal "unit_cost_of_vaccine", precision: 8, scale: 2, default: "0.0", null: false
    t.index ["code"], name: "index_campaigns_on_code", unique: true
    t.index ["district_id"], name: "index_campaigns_on_district_id"
    t.index ["region_id"], name: "index_campaigns_on_region_id"
    t.index ["type_of_campaign_id"], name: "index_campaigns_on_type_of_campaign_id"
  end

  create_table "cards", force: :cascade do |t|
    t.bigint "farmer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "card_number"
    t.index ["farmer_id"], name: "index_cards_on_farmer_id"
  end

  create_table "case_symptoms", force: :cascade do |t|
    t.bigint "case_id"
    t.bigint "symptom_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["case_id"], name: "index_case_symptoms_on_case_id"
    t.index ["symptom_id"], name: "index_case_symptoms_on_symptom_id"
  end

  create_table "cases", force: :cascade do |t|
    t.integer "type_of_case", default: 0
    t.bigint "species_id"
    t.bigint "user_id"
    t.string "pictures", default: [], array: true
    t.jsonb "location", default: "{}", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "age"
    t.string "sex"
    t.string "system"
    t.integer "number_dead"
    t.integer "number_at_risk"
    t.integer "number_examined"
    t.string "measures_adopted"
    t.text "epidemiology"
    t.text "tentative_diagnosis"
    t.text "differential_diagnosis"
    t.boolean "samples_sent_to_lab", default: false
    t.date "date_of_sample_submission"
    t.integer "status", default: 0
    t.string "basis_for_diagnosis", default: [], array: true
    t.string "community"
    t.string "district"
    t.string "details_of_diagnosis"
    t.string "name_of_laboratory"
    t.bigint "district_id"
    t.bigint "zone_id"
    t.index ["district_id"], name: "index_cases_on_district_id"
    t.index ["species_id"], name: "index_cases_on_species_id"
    t.index ["user_id"], name: "index_cases_on_user_id"
    t.index ["zone_id"], name: "index_cases_on_zone_id"
  end

  create_table "commissions", force: :cascade do |t|
    t.decimal "amount", precision: 8, scale: 2
    t.bigint "user_id"
    t.bigint "payment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["payment_id"], name: "index_commissions_on_payment_id"
    t.index ["user_id"], name: "index_commissions_on_user_id"
  end

  create_table "communities", force: :cascade do |t|
    t.string "address"
    t.decimal "lat", precision: 10, scale: 6
    t.decimal "lng", precision: 10, scale: 6
    t.bigint "zone_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address"], name: "index_communities_on_address", unique: true
    t.index ["zone_id"], name: "index_communities_on_zone_id"
  end

  create_table "disease_symptoms", force: :cascade do |t|
    t.bigint "disease_id"
    t.bigint "symptom_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["disease_id"], name: "index_disease_symptoms_on_disease_id"
    t.index ["symptom_id"], name: "index_disease_symptoms_on_symptom_id"
  end

  create_table "diseases", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.index ["name"], name: "index_diseases_on_name", unique: true
  end

  create_table "districts", force: :cascade do |t|
    t.string "name"
    t.bigint "region_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_districts_on_name", unique: true
    t.index ["region_id"], name: "index_districts_on_region_id"
  end

  create_table "farmer_payments", force: :cascade do |t|
    t.bigint "farmer_id"
    t.bigint "payment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "credit"
    t.decimal "debit"
    t.string "description"
    t.index ["farmer_id"], name: "index_farmer_payments_on_farmer_id"
    t.index ["payment_id"], name: "index_farmer_payments_on_payment_id"
  end

  create_table "farmers", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "phone_number"
    t.string "sex"
    t.integer "age"
    t.string "level_of_education"
    t.string "region"
    t.string "district"
    t.string "community"
    t.string "household_name"
    t.string "house_id"
    t.string "farm_name"
    t.string "farm_location"
    t.string "livestock_keeping_reason"
    t.string "years_since_farm_started"
    t.boolean "sheep_kept", default: false
    t.integer "number_of_exotic_sheep"
    t.integer "number_of_mixed_sheep"
    t.integer "number_of_crossed_sheep"
    t.integer "number_of_local_sheep"
    t.boolean "goats_kept", default: false
    t.integer "number_of_exotic_goats"
    t.integer "number_of_local_goats"
    t.integer "number_of_crossed_goats"
    t.integer "number_of_mixed_goats"
    t.boolean "pigs_kept", default: false
    t.integer "number_of_local_pigs"
    t.integer "number_of_exotic_pigs"
    t.integer "number_of_crossed_pigs"
    t.integer "number_of_mixed_pigs"
    t.boolean "cattle_kept", default: false
    t.integer "number_of_local_cattle"
    t.integer "number_of_exotic_cattle"
    t.integer "number_of_mixed_cattle"
    t.integer "number_of_crossed_cattle"
    t.boolean "chicken_kept", default: false
    t.integer "number_of_local_chicken"
    t.integer "number_of_exotic_chicken"
    t.integer "number_of_crossed_chicken"
    t.integer "number_of_mixed_chicken"
    t.boolean "draught_animals_kept", default: false
    t.integer "number_of_donkeys"
    t.integer "number_of_horses"
    t.integer "number_of_bullocks"
    t.integer "number_of_other_draught_animals"
    t.string "cattle_housing_system"
    t.string "goats_and_sheep_housing_system"
    t.string "pigs_housing_system"
    t.string "chicken_housing_system"
    t.boolean "cattle_vaccinated_this_year", default: false
    t.string "type_of_cattle_vaccination", default: [], array: true
    t.string "period_of_cattle_vaccination"
    t.boolean "sheep_and_goats_vaccinated_this_year", default: false
    t.string "type_of_sheep_and_goats_vaccination", default: [], array: true
    t.string "period_of_sheep_and_goats_vaccination"
    t.string "source_of_feeding"
    t.string "production_challenges", default: [], array: true
    t.boolean "own_a_phone", default: false
    t.string "type_of_phone"
    t.string "phone_is_used_for", default: [], array: true
    t.boolean "use_mobile_money", default: false
    t.string "how_phone_is_charged"
    t.string "how_airtime_is_topped_up", default: [], array: true
    t.string "action_taken_when_animal_is_sick"
    t.string "action_taken_when_animal_care_info_is_needed"
    t.string "how_disease_outbreak_is_known"
    t.string "action_taken_when_disease_outbreak"
    t.boolean "have_bank_account", default: false
    t.string "type_of_bank"
    t.boolean "bank_saving", default: false
    t.string "type_of_bank_saving"
    t.string "service_subscription", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "location", default: {}, null: false
    t.string "picture"
    t.string "last_use_of_mobile_money"
    t.string "why_not_use_mobile_money"
    t.string "id_type"
    t.string "id_number"
    t.string "languages_spoken", default: [], array: true
    t.boolean "birds_vaccinated_this_year"
    t.string "period_of_birds_vaccination"
    t.string "type_of_birds_vaccination", default: [], array: true
    t.boolean "have_internet", default: false
    t.bigint "zone_id"
    t.integer "number_of_sheep"
    t.integer "number_of_goats"
    t.integer "number_of_cattle"
    t.integer "number_of_chicken"
    t.integer "number_of_pigs"
    t.boolean "subscribed", default: false
    t.bigint "region_id"
    t.bigint "district_id"
    t.string "alternate_phone_number"
    t.string "slug"
    t.boolean "is_livestock_farmer", default: false
    t.boolean "is_crop_farmer", default: false
    t.boolean "is_farm_maize", default: false
    t.boolean "is_farm_rice", default: false
    t.boolean "is_farm_soyabeans", default: false
    t.boolean "is_farm_sorghum", default: false
    t.boolean "is_farm_cocoa", default: false
    t.boolean "is_farm_yam", default: false
    t.integer "acres_of_maize_farm"
    t.integer "acres_of_rice_farm"
    t.integer "acres_of_soyabeans_farm"
    t.integer "acres_of_sorghum_farm"
    t.integer "acres_of_cocoa_farm"
    t.integer "acres_of_yam_farm"
    t.string "mode_of_farming"
    t.boolean "is_use_fertilizer", default: false
    t.string "source_of_buying_fertilizer", array: true
    t.boolean "is_purchase_tractor_services", default: false
    t.boolean "is_purchase_seeds", default: false
    t.string "source_of_buying_seeds", array: true
    t.integer "number_of_npk_bags", default: 0, null: false
    t.integer "number_of_urea_bags", default: 0, null: false
    t.integer "number_of_soa_bags", default: 0, null: false
    t.string "types_of_fertilizers", array: true
    t.boolean "is_deleted", default: false, null: false
    t.bigint "community_id"
    t.index ["alternate_phone_number"], name: "index_farmers_on_alternate_phone_number"
    t.index ["community_id"], name: "index_farmers_on_community_id"
    t.index ["district_id"], name: "index_farmers_on_district_id"
    t.index ["phone_number"], name: "index_farmers_on_phone_number", unique: true
    t.index ["region_id"], name: "index_farmers_on_region_id"
    t.index ["zone_id"], name: "index_farmers_on_zone_id"
  end

  create_table "friendly_id_slugs", id: :serial, force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "messages", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "message_id"
    t.string "voice_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "messages_id"
    t.boolean "scheduled"
    t.datetime "send_at"
    t.boolean "sent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["messages_id"], name: "index_notifications_on_messages_id"
  end

  create_table "organization_farmers", force: :cascade do |t|
    t.bigint "organization_id"
    t.bigint "farmer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["farmer_id"], name: "index_organization_farmers_on_farmer_id"
    t.index ["organization_id"], name: "index_organization_farmers_on_organization_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.string "postal_address"
    t.integer "number_of_staff"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "region"
    t.string "district"
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "subscription_id"
    t.decimal "payment_fee", precision: 8, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "payment_method"
    t.string "item", default: "", null: false
    t.string "debit_credit"
    t.decimal "amount"
    t.string "description"
    t.string "transaction_number"
    t.index ["subscription_id"], name: "index_payments_on_subscription_id"
  end

  create_table "pricing_plans", force: :cascade do |t|
    t.decimal "price", precision: 8, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "plan_type"
    t.index ["name"], name: "index_pricing_plans_on_name", unique: true
  end

  create_table "provider_campaigns", force: :cascade do |t|
    t.bigint "campaign_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_provider_campaigns_on_campaign_id"
    t.index ["user_id"], name: "index_provider_campaigns_on_user_id"
  end

  create_table "regions", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_regions_on_name", unique: true
  end

  create_table "smile_users", force: :cascade do |t|
    t.string "uuid"
    t.string "job_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "species", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_species_on_name", unique: true
  end

  create_table "species_diseases", force: :cascade do |t|
    t.bigint "species_id"
    t.bigint "disease_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["disease_id"], name: "index_species_diseases_on_disease_id"
    t.index ["species_id"], name: "index_species_diseases_on_species_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.datetime "expires_on"
    t.integer "duration"
    t.bigint "farmer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "pricing_plan_id"
    t.decimal "total_cost_of_subscription", precision: 8, scale: 2
    t.decimal "total_amount_paid", precision: 8, scale: 2
    t.decimal "total_amount_due", precision: 8, scale: 2
    t.integer "type_of_subscription", default: 0, null: false
    t.index ["farmer_id"], name: "index_subscriptions_on_farmer_id"
    t.index ["pricing_plan_id"], name: "index_subscriptions_on_pricing_plan_id"
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "symptoms", force: :cascade do |t|
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "type_of_campaigns", force: :cascade do |t|
    t.string "type_of_campaign"
    t.integer "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_type_of_campaigns_on_code", unique: true
    t.index ["type_of_campaign"], name: "index_type_of_campaigns_on_type_of_campaign", unique: true
  end

  create_table "user_farmers", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "farmer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["farmer_id"], name: "index_user_farmers_on_farmer_id"
    t.index ["user_id"], name: "index_user_farmers_on_user_id"
  end

  create_table "user_organizations", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "organization_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_user_organizations_on_organization_id"
    t.index ["user_id"], name: "index_user_organizations_on_user_id"
  end

  create_table "user_payments", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "payment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "credit"
    t.decimal "debit"
    t.string "description"
    t.index ["payment_id"], name: "index_user_payments_on_payment_id"
    t.index ["user_id"], name: "index_user_payments_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "first_name"
    t.string "last_name"
    t.string "phone_number"
    t.jsonb "location", default: "{}", null: false
    t.string "gender"
    t.string "region"
    t.string "district"
    t.string "type_of_id"
    t.string "id_number"
    t.string "picture"
    t.date "date_of_birth"
    t.integer "role", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.json "tokens"
    t.string "username"
    t.string "slug"
    t.string "device_ids", default: [], null: false, array: true
    t.bigint "zone_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["phone_number"], name: "index_users_on_phone_number", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
    t.index ["zone_id"], name: "index_users_on_zone_id"
  end

  create_table "vaccination_schedules", force: :cascade do |t|
    t.string "activity"
    t.integer "herd_size"
    t.bigint "zone_id"
    t.text "notes"
    t.bigint "farmer_id"
    t.bigint "campaign_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "animal_group"
    t.bigint "type_of_campaign_id"
    t.integer "status", default: 0
    t.integer "number_of_animals_vaccinated", default: 0, null: false
    t.decimal "total_charge_for_vaccinations", precision: 8, scale: 2, default: "0.0", null: false
    t.date "completion_date"
    t.date "reschedule_date"
    t.text "reschedule_reason"
    t.index ["campaign_id"], name: "index_vaccination_schedules_on_campaign_id"
    t.index ["farmer_id"], name: "index_vaccination_schedules_on_farmer_id"
    t.index ["type_of_campaign_id"], name: "index_vaccination_schedules_on_type_of_campaign_id"
    t.index ["zone_id"], name: "index_vaccination_schedules_on_zone_id"
  end

  create_table "zones", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "district_id"
    t.integer "code"
    t.index ["district_id"], name: "index_zones_on_district_id"
    t.index ["name"], name: "index_zones_on_name", unique: true
  end

  add_foreign_key "animal_tag_vaccinations", "animal_tags"
  add_foreign_key "animal_tag_vaccinations", "users"
  add_foreign_key "animal_tags", "farmers"
  add_foreign_key "campaign_messages", "campaigns"
  add_foreign_key "campaign_messages", "messages"
  add_foreign_key "campaign_subscriptions", "campaigns"
  add_foreign_key "campaign_subscriptions", "farmers"
  add_foreign_key "campaign_zones", "campaigns"
  add_foreign_key "campaign_zones", "zones"
  add_foreign_key "campaigns", "districts"
  add_foreign_key "campaigns", "regions"
  add_foreign_key "campaigns", "type_of_campaigns"
  add_foreign_key "cards", "farmers"
  add_foreign_key "case_symptoms", "cases"
  add_foreign_key "case_symptoms", "symptoms"
  add_foreign_key "cases", "districts"
  add_foreign_key "cases", "species"
  add_foreign_key "cases", "users"
  add_foreign_key "cases", "zones"
  add_foreign_key "commissions", "payments"
  add_foreign_key "commissions", "users"
  add_foreign_key "communities", "zones"
  add_foreign_key "disease_symptoms", "diseases"
  add_foreign_key "disease_symptoms", "symptoms"
  add_foreign_key "districts", "regions"
  add_foreign_key "farmer_payments", "farmers"
  add_foreign_key "farmer_payments", "payments"
  add_foreign_key "farmers", "communities"
  add_foreign_key "farmers", "districts"
  add_foreign_key "farmers", "regions"
  add_foreign_key "farmers", "zones"
  add_foreign_key "notifications", "messages", column: "messages_id"
  add_foreign_key "organization_farmers", "farmers"
  add_foreign_key "organization_farmers", "organizations"
  add_foreign_key "payments", "subscriptions"
  add_foreign_key "provider_campaigns", "campaigns"
  add_foreign_key "provider_campaigns", "users"
  add_foreign_key "species_diseases", "diseases"
  add_foreign_key "species_diseases", "species"
  add_foreign_key "subscriptions", "farmers"
  add_foreign_key "subscriptions", "pricing_plans"
  add_foreign_key "subscriptions", "users"
  add_foreign_key "user_farmers", "farmers"
  add_foreign_key "user_farmers", "users"
  add_foreign_key "user_organizations", "organizations"
  add_foreign_key "user_organizations", "users"
  add_foreign_key "user_payments", "payments"
  add_foreign_key "user_payments", "users"
  add_foreign_key "users", "zones"
  add_foreign_key "vaccination_schedules", "campaigns"
  add_foreign_key "vaccination_schedules", "farmers"
  add_foreign_key "vaccination_schedules", "type_of_campaigns"
  add_foreign_key "vaccination_schedules", "zones"
  add_foreign_key "zones", "districts"
end
