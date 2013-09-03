class PeopleController < ApplicationController
  skip_before_filter :verify_authenticity_token
  respond_to 'json'

  def show
    person = find_person
    if person.nil?
      render :text => :nil, :status => :not_found
    else
      respond_with person
    end
  end

  def create
    person = Person.create(person_params)
    respond_with person
  end

  def update
    person = Person.find(person_id)
    person.update_attributes!(person_params)
    respond_with person
  end

  def destroy
    begin
      person = Person.find(person_id)
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

  def person_id
    params[:id].to_i
  end

  def person_sample
    Person.new(
      :id => 1,
      :first_name => "Stacey",
      :last_name => "Vetzal",
      :phone => "905-555-1212",
      :email => "stacey@threewisemen.ca",
      :created_at => Time.now,
      :updated_at => Time.now
    )
  end

  def find_person
    person = nil
    begin
      person = Person.find(person_id)
    rescue
      # We want to fake out a person for ID 1 so there's
      # always one in the db to reference for tests.
      person = person_sample if person_id == 1
    end
    return person
  end
end
