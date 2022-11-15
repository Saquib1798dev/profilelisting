class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found
  # before_action :authenticate

  # def authenticate
  #   data = JWT.decode(request.headers['authorization'].split(' ').last,"", false)
  #   if data.present?
  #     exp_time = Time.at(data[0]["exp"])
  #     user = User.find_by_id(data[0]["sub"])
  #     unless Time.now < exp_time && user.present?
  #       return  render json: { message: "Invalid Token", success: false }
  #     end
  #   else
  #     return  render json: { message: "Invalid Token", success: false } 
  #   end 
  # end
  
  private

  def handle_record_not_found
    render json: {success: false, message: "Record Not found"}
  end

  
end
