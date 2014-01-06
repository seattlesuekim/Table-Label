class LabelController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def ask
    render 'questions'
  end

  def create
    @diet = Label.create_from_questions(params)
    render 'show_diet'
  end

  def retrieve
    render 'retrieve'
  end

  def break_down
    @label_array = Label.create_array_of_labels(params)
    @party = Party.new(@label_array)
    render 'display'
  end
end



