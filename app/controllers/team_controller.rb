class TeamController < ApplicationController
  def index
    @people = Person.all
  end
end
