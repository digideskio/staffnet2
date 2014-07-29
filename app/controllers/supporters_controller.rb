class SupportersController < ApplicationController

  include Pundit
  after_filter :verify_authorized

  def new
    @supporter = Supporter.new
    @supporter_types = SupporterType.all
    authorize @supporter
  end

  def create
    @supporter_type = SupporterType.find(params[:supporter][:supporter_type_id])
    @supporter = @supporter_type.supporters.build(supporter_params)
    authorize @supporter
    if @supporter.save
      new_supporter_tasks(@supporter)
      redirect_to supporter_path(@supporter)
    else
      render 'new'
    end
  end

  def show
    @supporter = Supporter.find(params[:id])
    @donations = @supporter.donations
    @supporter_type = @supporter.supporter_type
    authorize @supporter
  end

  def index
    @search = Supporter.search(params[:q])
    @supporters = @search.result
    @search.build_condition
    authorize @supporters
  end

  def edit
    @supporter = Supporter.find(params[:id])
    authorize @supporter
  end

  def update
    @supporter = Supporter.find(params[:id])
    authorize @supporter
    if @supporter.update_attributes(supporter_params)
      flash[:success] = 'Supporter updated.'
      redirect_to supporter_path(@supporter)
    else
      render 'edit'
    end
  end

  def destroy
    supporter = Supporter.find(params[:id])
    authorize supporter
    destroy_supporter_tasks(supporter)
    supporter.destroy
    redirect_to supporters_url
  end

  private

    def new_supporter_tasks(supporter)
      # generate an id for the cim customer id field. add 20,000 to the supporter id
      # the service object will save the new supporter
      supporter.generate_cim_customer_id
      sendy_list = supporter.supporter_type.sendy_lists.first
      service = SupporterService.new(supporter, sendy_list.id, supporter.email_1 )
      service.new_supporter ? flash[:success] = 'Saved new supporter.' : flash[:alert] = "Error: #{service.message}"
    end

    def destroy_supporter_tasks(supporter)
      sendy_list = supporter.supporter_type.sendy_lists.first
      service = SupporterService.new(supporter, sendy_list.id, supporter.email_1, '', '', supporter.cim_id )
      service.destroy_supporter ? flash[:success] = 'Supporter record destroyed.' : flash[:alert] = "Error: #{service.message}"
    end

    def supporter_params
      params.require(:supporter).permit(  :prefix, :salutation, :first_name, :last_name, :suffix, :address_line_1,
                                          :address_line_2, :address_city, :address_state, :address_zip, :address_bad,
                                          :email_1, :email_1_bad, :email_2, :email_2_bad, :phone_mobile,
                                          :phone_mobile_bad, :phone_home, :phone_home_bad, :supporter_type_id,
                                          :do_not_call, :do_not_email, :do_not_mail, :keep_informed, :vol_level,
                                          :employer, :occupation, :tag_list, :address_county)
    end
end