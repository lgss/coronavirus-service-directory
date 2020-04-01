class ServicesController < ApplicationController
    #http_basic_authenticate_with name: "ncc", password: "covid19"
    include Secured
    
    def search
        @categories = Service.categories
    end

    def index
        results = Geocoder.search(params[:postcode], region: "gb")
        if results.length > 0
            @result = results.first.formatted_address
            @coordinates = Geocoder.coordinates(params[:postcode])
            if params[:categories]
                @services = Service.where("category && ARRAY[?]::varchar[]", params[:categories])
                if !params[:individual].present? and params[:group].present?
                    @services = @services.filter_by_who(params[:group])
                end
                if params[:individual].present? and !params[:group].present?
                    @services = @services.filter_by_who(params[:individual])
                end
                @services = @services.near(results.first.coordinates, 200)
            else
                @services = Service.near(results.first.coordinates, 200)
                if !params[:individual].present? and params[:group].present?
                    @services = @services.filter_by_who(params[:group])
                end
                if params[:individual].present? and !params[:group].present?
                    @services = @services.filter_by_who(params[:individual])
                end
                # byebug
            end
        else
            redirect_to search_services_path, :notice => "Couldn't find any services near that location. Please make sure your location is a valid Northamptonshire area."
        end
    end 

end