class CredentialsController < ApplicationController
  before_action :set_credential, only: [:show, :edit, :edit_document, :update, :destroy]

  # GET /credentials
  def index
    @credentials = Credential.access_groups(access_group_ids).
                              filter_by(filter_params).
                              ordered.
                              page(params[:page])
  end

  # GET /credentials/1
  def show
    render :edit
  end

  # GET /credentials/new
  def new
    @credential = Credential.new(access_group: default_access_group)
  end

  # GET /credentials/1/edit_document
  def edit_document
    # FIXME:  don't expose the token to the public
    # @credential.token = nil
    # password is set in the update method
    @credential.password = session[:password]
    session[:password] = nil
    if !@credential.secured || (@credential.secured && !@credential.password.blank?)
      @credential.document
    end
    render :edit, status: @credential.valid? ? :ok : :forbidden
  end

  # GET /credentials/1/edit
  def edit
    # FIXME: don't expose the token to the public
    # @credential.token = nil
  end

  # POST /credentials
  def create
    @credential = Credential.new(credential_params)

    if @credential.save
      redirect_to @credential, notice: t('.notice', default: 'Credential was successfully created.')
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /credentials/1
  def update
    unless params[:decrypt].blank?
      session[:password] = params[:credential][:password]
      redirect_to edit_document_credential_path(@credential)
    else
      if @credential.update(credential_params)
        redirect_to @credential, notice: t('.notice', default: 'Credential was successfully updated.')
      else
        render :edit, status: :unprocessable_entity
      end
    end
  end

  # DELETE /credentials/1
  def destroy
    @credential.destroy
    redirect_to credentials_url, notice: t('.notice', default: 'Credential was successfully destroyed.')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_credential
      @credential = Credential.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def credential_params
      params.require(:credential).permit(:title, :url, :login, :comment, :secured, :password, :document, :access_group_id)
    end
    def filter_params
      params.slice(:title_filter, :url_filter)
    end

    def access_group_ids
      current_user.access_groups.map { |g| g.id }
    end
    def default_access_group
      current_user.default_access_group
    end
end
