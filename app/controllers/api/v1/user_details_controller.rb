module Api
  module V1
    class UserDetailsController < ApplicationController
      before_action :get_user
      before_action :get_complete_image_url, only: [:show, :update]
      before_action :update_type_field, only: [:generate_otp]
      before_action :compare_current_password, only: [:change_password]

      def show
        render json: { data: @user, avatar: @complete_image_url }
      end

      def update
        @user.update(user_params)
        render json: { data: @user, avatar:  @complete_image_url  }
      end

      def verify_otp
        otp = @user.otps.where(["otp_digits = ?", "#{params[:user][:otp]}"]).first
        if otp.present?
          if update_email_or_phone_number(@user, otp)
            if otp.update(otp_verified: true)
              render json: {otp_data: otp, data: @user, message: "Otp has been verified and the field has been updated", success: true}, status: :ok
            end
          else
            render json: {message: "Email or Phone number was not updated", status: false}, status: :unprocessable_entity
          end 
        else
          render json: {message: "Incorrect Otp no field updated", status: false }, status: :unprocessable_entity
        end
      end

      def destroy
      end

      def generate_otp
        render json: {data: @user, otp: @user.otps,  message: "Otp for updation ", success: true}
      end

      def change_password
        if @equal
          new_password = params[:user][:new_password]
          if @user.update(password: new_password)
            render json: { data: @user, message: "Password Updated", success: true}, status: :ok
          else
            render json: { data: @user, message: "Password Not Updated", success: false}, status: :unprocessable_entity
          end
        else
          render json: {message: "Incorrect Current Password", success: false}, status: :unprocessable_entity
        end
      end

      private

      def update_type_field
        if params[:user][:update_type] == "email_update" || params[:user][:update_type_two] == "email_update"
          @otp = @user.otps.where(otp_type: "email_update").first
          if @otp.present?
            @otp.update(otp_digits: rand(1000..9999), otp_verified: false, otp_token: SecureRandom.hex)
          else
            type = "email_update"
           @otp =  create_otp(@user, type)
          end 
        elsif params[:user][:update_type] == "phone_update" || params[:user][:update_type_two] == "phone_update"
          @otp = @user.otps.where(otp_type: "phone_update").first
          if @otp.present?
            @otp.update(otp_digits: rand(1000..9999), otp_verified: false, otp_token: SecureRandom.hex)
          else
            type = "phone_update"
            @otp = create_otp(@user, type)
          end 
        end
      end

      def compare_current_password
        current_password = params[:user][:current_password]
        if @user.valid_password?(current_password)
          @equal  = true 
        else
          @equal = false
        end
      end

      def user_params
        params.permit(:full_name, :avatar)
      end

      def update_email_or_phone_number(user, otp)
        if otp.otp_type == "email_update"
          user.update(email: params[:user][:email])
        elsif otp.otp_type == "phone_update"
          user.update(full_phone_number: params[:user][:full_phone_number])
        end
      end

      def get_complete_image_url
        @base_url = "#{request.protocol}#{request.host_with_port}"
        @complete_image_url = @base_url+Rails.application.routes.url_helpers.rails_blob_path(@user.avatar, only_path: true)
      end

      def create_otp(user, type)
        @otp = user.otps.create(otp_digits: rand(1000..9999), otp_type: type, otp_verified: false, otp_token: SecureRandom.hex)
      end

      def get_user
        @user = User.find(params[:id])
      end
    end
  end
end
