namespace :zones do
	ZONES_PATH = "#{Rails.public_path}/raw/Zones.xlsx"
	def read_zones
	  zones = []
	  xlsx = Roo::Spreadsheet.open(ZONES_PATH)
	  sheet = xlsx.sheet(xlsx.sheets[0])
	  sheet.each_with_index(
	    name: 'Name',
	    code: 'Code'
	  ) do |hash, i|
	  	# skip first row
	    next if i.zero?
	    new_zones = build_new_zones(hash)
	    zones.concat(new_zones)
	  end
	  zones
	end

	def build_new_zones(hash)
	  return if hash[:name].nil? || hash[:code].nil?
	  z_name = hash[:name].delete("\n")
	  code = hash[:code].to_i
	  district = District.find_by_name(z_name)
	  zones = []
	  unless district.nil?
	  	(1..6).each do |n|
	  		zone_name = z_name + ' Zone' + ' ' + n.to_s
	  		zones << Zone.new(name: zone_name, code: n == 1 ? code : (code + (n - 1)), district_id: district.id)
	  	end
	  end
	  zones
	end

  desc "import zones from excel doc"
  task import: :environment do
  	zones = read_zones
  	Zone.import(zones, recursive: true)
  end

end