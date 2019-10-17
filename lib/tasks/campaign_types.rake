namespace :campaign_types do
	CAMPAIGN_TYPES_PATH = "#{Rails.public_path}/raw/CampaignTypes.xlsx"
	def read_campaign_types
	  campaign_types = []
	  xlsx = Roo::Spreadsheet.open(CAMPAIGN_TYPES_PATH)
	  sheet = xlsx.sheet(xlsx.sheets[0])
	  sheet.each_with_index(
	    name: 'name',
	    code: 'code'
	  ) do |hash, i|
	  	# skip first row
	    next if i.zero?
	    campaign_type = build_new_campaign_type(hash)
	    campaign_types << campaign_type unless campaign_type.nil?
	  end
	  campaign_types
	end

	def build_new_campaign_type(hash)
		return if hash[:name].nil? || hash[:code].nil?
		campaign_type = TypeOfCampaign.new(
		  type_of_campaign: hash[:name].delete("\n"),
		  code: hash[:code].delete("\n")
		)
		campaign_type
	end

  desc "import campaign_types from excel doc"
  task import: :environment do
  	campaign_types = read_campaign_types
  	TypeOfCampaign.import(campaign_types, recursive: true)
  end

end
