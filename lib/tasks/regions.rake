namespace :regions do
	REGIONS_PATH = "#{Rails.public_path}/raw/Regions.xlsx"
	def read_regions
	  regions = []
	  xlsx = Roo::Spreadsheet.open(REGIONS_PATH)
	  sheet = xlsx.sheet(xlsx.sheets[0])
	  sheet.each_with_index(
	    name: 'Name',
	    districts: 'Districts'
	  ) do |hash, i|
	  	# skip first row
	    next if i.zero?
	    region = build_new_record(hash)
	    regions << region unless region.nil?
	  end
	  regions
	end

	def build_new_record(hash)
	  return if hash[:name].nil? || hash[:districts].nil?
	  districts = hash[:districts].split(',')
	  region = Region.new(
	    name: hash[:name].delete("\n")
	  )
	  districts.each do |d|
	    district = d.delete("\n")
	    next if district.empty?
	    region.districts.build(name: district)
	  end
	  region
	end

  desc "import regions from excel doc"
  task import: :environment do
  	regions = read_regions
  	Region.import(regions, recursive: true)
  end
end
