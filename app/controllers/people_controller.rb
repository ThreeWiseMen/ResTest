class PeopleController < ApplicationController
  skip_before_filter :verify_authenticity_token
  respond_to 'json'

  def show
    begin
      person = Person.find(params[:id])
      respond_with person
    rescue
      render :text => :nil, :status => :not_found
    end
  end

  def create
    person = Person.create(person_params)
    respond_with person
  end

  def update
    person = Person.find(params[:id])
    person.update_attributes!(person_params)
    respond_with person
  end

  def destroy
    begin
      person = Person.find(params[:id])
      person.destroy!
      respond_with nil
    rescue
      render :text => :nil, :status => :not_found
    end
  end

  private

  def person_params
    params.require(:person).permit(:first_name, :last_name, :phone, :email)
  end
end
