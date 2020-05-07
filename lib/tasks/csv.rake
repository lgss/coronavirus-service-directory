require 'csv'

task :csv => :environment do
    Service.destroy_all

    response = HTTParty.get(ENV["DATASOURCE"])
    rows = CSV.parse(response.body, headers: true)

    # byebug

    rows.each do |row|
        service = Service.new
        #service.form_id = row[0]
        if row['areYouApplyingAs'].downcase == "individual"
            # individual
            service.name = row['First_name'].capitalize
            service.name << " "
            service.name << row['Surname'].capitalize
            
            service.description = "Individual"
            
            #service.url = row[9]
            service.email = row['emailAddress']
            service.phone = row['telephoneNumber'] && !row['telephoneNumber'].start_with?('0','+44') ? '0' << row['telephoneNumber'] : row['telephoneNumber']
            service.postcode = row['address_personal_postcodemanual']
            #service.availability = row[22]

            # categories
            categories = []
            row['whatSupportCanYou'].delete! '[]' # remove existing array brackets
            categories = row['whatSupportCanYou'].split(",") # comma separated so split the string
            categories.each(&:lstrip!) # strip whitespace on each array index
            service.category = categories # add to service object
            
            # service.recommended = row[15]
            service.key_point_1 = row['whatIsYourAvailab'].capitalize #availabiility
            #service.key_point_2 = 'Areas covered ' << row[44] #areas
            #service.key_point_3 = 'Further support offered ' << row[45] #further support
            # service.how_to_contact = row[19]

            #puts service.inspect
        else
            
            # business
            service.name = row['groupOrBusinessNa']
            service.description = 'Contact ' << row['contactName']
            #service.url = row[9]
            service.phone = row['telephoneNumber_BorG'] && !row['telephoneNumber_BorG'].start_with?('0','+44') ? '0' << row['telephoneNumber_BorG'] : row['telephoneNumber_BorG']
            service.email = row['emailAddress_BorG'] ? row['emailAddress_BorG'] : ""
            service.postcode = row['address_BorG_postcodemanual'] ? row['address_BorG_postcodemanual'] : row['address_BorG_postcode']
            # categories
            categories = []
            row['whatSupportCanYou1'].delete! '[]' # remove existing array brackets
            categories = row['whatSupportCanYou1'].split(",") # comma separated so split the string
            categories.each(&:lstrip!) # strip whitespace on each array index
            service.category = categories # add to service object

            service.key_point_1 = row['whatIsYourAvailab1'].capitalize #availabiility
            service.key_point_2 = 'Areas covered ' << row['whatAreasDoYouCo'] #areas
            service.key_point_3 = 'Further support required: ' << row['whatFurtherSupport'] #further support
            puts service.inspect
        end
        service.save
    end
    puts '🎉 Done. 🎉'
end