class TranslationsController < ApplicationLesliController
    before_action :set_translation, only: [:show, :edit, :update, :destroy]

    # GET /translations
    def index

        responseWithSuccessful()

    end

    # GET /translations/1
    def show
    end

    # GET /translations/new
    def new
    end

    # GET /translations/1/edit
    def edit
    end
 
    # POST /translations
    def create
    end

    # PATCH/PUT /translations/1
    def update
    end

    # DELETE /translations/1
    def destroy
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_translation
    end

    # Only allow a trusted parameter "white list" through.
    def translation_params
    end
end
