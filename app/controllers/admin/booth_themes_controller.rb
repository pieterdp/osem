class Admin::BoothThemesController < ApplicationController

  def index
    @file_name = "#{(t 'booth').pluralize}_for_#{@conference.short_title}"
    @booth_export_option = params[:booth_export_option]
    respond_to do |format|
      format.html
      # Explicity call #to_json to avoid the use of EventSerializer
      format.json { render json: Booth.where(state: :confirmed, program: @program).to_json }
      format.xlsx do
        response.headers['Content-Disposition'] = "attachment; filename=\"#{@file_name}.xlsx\""
        render 'booths', layout: false
      end
      format.pdf { render 'booths', layout: false }
      format.csv do
        response.headers['Content-Disposition'] = "attachment; filename=\"#{@file_name}.csv\""
        render 'booths', layout: false
      end
    end
  end

  def show; end

  def new
    @url = admin_conference_booths_path(@conference.short_title)
  end

  def create
    @url = admin_conference_booths_path(@conference.short_title)

    @booth = @conference.booths.new(booth_params)

    @booth.submitter = current_user

    if @booth.save
      redirect_to admin_conference_booths_path,
                  notice: "#{(t 'booth').capitalize} successfully created."
    else
      flash.now[:error] = "Creating #{t 'booth'} failed. #{@booth.errors.full_messages.to_sentence}."
      render :new
    end
  end

  def edit
    @url = admin_conference_booth_path(@conference.short_title, @booth.id)
  end

  def update
    @url = admin_conference_booth_path(@conference.short_title, @booth.id)

    @booth.update_attributes(booth_params)

    if @booth.save
      redirect_to admin_conference_booths_path,
                  notice: "Successfully updated #{t 'booth'} for #{@booth.title}."
    else
      flash.now[:error] = "An error prohibited the #{t'booth'} for #{@booth.title} "\
                    "#{@booth.errors.full_messages.join('. ')}."
      render :edit
    end
  end


  def booth_params
    params.require(:booth).permit(:title, :description, :reasoning, :state, :picture, :conference_id,
                                  :created_at, :updated_at, :submitter_relationship, :website_url, responsible_ids: [])
  end

end
