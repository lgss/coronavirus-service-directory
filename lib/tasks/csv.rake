require 'csv'

task :csv => :environment do
    Service.destroy_all

    response = HTTParty.get(ENV["DATASOURCE"])
    rows = CSV.parse(response.body, headers: true)

    # byebug

    rows.each do |row|
        service = Service.new
        #service.form_id = row[0]
        if row[7].downcase == "individual"
            # individual
            service.name = row[9].capitalize
            service.name << " "
            service.name << row[10].capitalize
            
            service.description = "Individual"
            
            #service.url = row[9]
            service.email = row[11]
            service.phone = row[12] && !row[12].start_with?('0','+44') ? '0' << row[12] : row[12]
            service.postcode = row[19]
            #service.availability = row[22]

            # categories
            categories = []
            row[21].delete! '[]' # remove existing array brackets
            categories = row[21].split(",") # comma separated so split the string
            categories.each(&:lstrip!) # strip whitespace on each array index
            service.category = categories # add to service object
            
            # service.recommended = row[15]
            service.key_point_1 = row[22].capitalize #availabiility
            #service.key_point_2 = 'Areas covered ' << row[44] #areas
            #service.key_point_3 = 'Further support offered ' << row[45] #further support
            # service.how_to_contact = row[19]

            #puts service.inspect
        else
            # business
            service.name = row[28]
            service.description = 'Contact ' << row[29]
            #service.url = row[9]
            service.phone = row[31] && !row[31].start_with?('0','+44') ? '0' << row[31] : row[31]
            service.email = row[30]
            service.postcode = row[38]

            # categories
            categories = []
            row[42].delete! '[]' # remove existing array brackets
            categories = row[42].split(",") # comma separated so split the string
            categories.each(&:lstrip!) # strip whitespace on each array index
            service.category = categories # add to service object

            service.key_point_1 = row[43].capitalize #availabiility
            service.key_point_2 = 'Areas covered ' << row[44] #areas
            service.key_point_3 = 'Further support required: ' << row[45] #further support
        end

        service.save
    end
    puts '🎉 Done. 🎉'
end