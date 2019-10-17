namespace :diseases do
	DISEASES_PATH = "#{Rails.public_path}/raw/List-of-Common-Livestock-Diseases-in-Ghana.xlsx"
	def read_diseases
	  diseases = []
	  xlsx = Roo::Spreadsheet.open(DISEASES_PATH)
	  sheet = xlsx.sheet(xlsx.sheets[0])
	  sheet.each_with_index(
	    name: 'name',
	    description: 'description',
	    symptoms: 'symptoms',
	    affected_species: 'Affected Species'
	  ) do |hash, i|
	    next if i.zero?
	    disease = build_new_disease(hash)
	    diseases << disease unless disease.nil?
	  end
	  diseases
	end

	def build_new_disease(hash)
		return if hash[:name].nil? || hash[:description].nil? || hash[:symptoms].nil? || hash[:affected_species].nil?
		symptoms = hash[:symptoms].split('.')
		disease = Disease.new(
		  name: hash[:name].delete("\n"),
		  description: hash[:description].delete("\n")
		)
		symptoms.each do |symptom|
		  description = symptom.delete("\n")
		  next if description.empty?
		  disease.disease_symptoms.build(symptom_id: (Symptom.create(description: description)).id)
		end
		disease
	end

  desc "import diseases from excel doc"
  task import: :environment do
  	diseases = read_diseases
  	Disease.import(diseases, recursive: true)
  end

end
