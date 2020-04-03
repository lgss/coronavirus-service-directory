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
            service.name = row[27]
            service.description = 'Contact ' << row[28]
            #service.url = row[9]
            service.phone = row[30] && !row[30].start_with?('0','+44') ? '0' << row[30] : row[30]
            service.email = row[29] ? row[29] : ""
            iputs service.inspect if service.name === 'Nikki Berridge'
            service.postcode = row[37] ? row[37] : row[32]
            # categories
            categories = []
            row[40].delete! '[]' # remove existing array brackets
            categories = row[40].split(",") # comma separated so split the string
            categories.each(&:lstrip!) # strip whitespace on each array index
            service.category = categories # add to service object

            service.key_point_1 = row[41].capitalize #availabiility
            service.key_point_2 = 'Areas covered ' << row[42] #areas
            service.key_point_3 = 'Further support required: ' << row[43] #further support
        end
        puts service.inspect
        service.save
    end
    puts '🎉 Done. 🎉'
end