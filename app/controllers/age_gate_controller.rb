class AgeGateController < ApplicationController
  skip_before_action :require_age_verification

  def show; end

  def create
    if params[:confirm] == "yes"
      session[:age_verified] = true
      redirect_to(session.delete(:return_to) || root_path, notice: "Thanks for confirming your age. Welcome in!")
    else
      redirect_to age_gate_path, alert: "You must be of legal age to enter this site."
    end
  end
end
