class CredentialsController < ApplicationController
  before_action :set_credential, only: [:show, :edit, :edit_document, :update, :destroy]

  # GET /credentials
  def index
    @credentials = Credential.all
  end

  # GET /credentials/1
  def show
    render :edit
  end

  # GET /credentials/new
  def new
    @credential = Credential.new
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
    else
      @credential.valid?
    end
    render :edit
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
      # redirect_to @credential, notice: 'Credential was successfully created.'
      redirect_to @credential, notice: 'Credential was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /credentials/1
  def update
    unless params[:decrypt].blank?
      session[:password] = params[:credential][:password]
      redirect_to edit_document_credential_path(@credential)
    else
      if @credential.update(credential_params)
        redirect_to @credential, notice: 'Credential was successfully updated.'
      else
        render :edit
      end
    end
  end

  # DELETE /credentials/1
  def destroy
    @credential.destroy
    redirect_to credentials_url, notice: 'Credential was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_credential
      @credential = Credential.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def credential_params
      params.require(:credential).permit(:title, :url, :login, :comment, :secured, :password, :document)
    end
end
