class  Api::V1::CaseSerializer < Api::BaseSerializer
  attributes(
    :id,
    :location,
    :pictures,
    :species_id,
    :species,
    :user_id,
    :age,
    :sex,
    :community,
    :system,
    :number_dead,
    :number_at_risk,
    :number_examined,
    :measures_adopted,
    :epidemiology,
    :tentative_diagnosis,
    :differential_diagnosis,
    :details_of_diagnosis,
    :basis_for_diagnosis,
    :samples_sent_to_lab,
    :symptom_ids,
    :date_of_sample_submission,
    :name_of_laboratory,
    :status,
    :created_at,
    :updated_at
  )

  has_many :symptoms, through: :case_symptoms
  belongs_to :district, optional: true, serializer: Api::V1::CustomDistrictSerializer
  belongs_to :zone, optional: true

  def species
    Species.find(object.species_id).try(:name)
  end

  def location
    if object.location.class == String
      eval(object.location)
    elsif object.location.class == Hash
      object.location
    end
  end

  def symptom_ids
    object.symptoms.pluck(:id)
  end
end