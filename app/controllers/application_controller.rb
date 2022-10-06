class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found
  
  private

  def handle_record_not_found
    render json: {success: false, message: "Record Not found"}
  end
  
end
