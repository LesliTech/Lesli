class Website::PagesController < WebsiteController
    before_action :set_website_page, only: [:show, :edit, :update, :destroy]

    def landing
        render :landing
    end


    # GET /website/pages
    def index
    @website_pages = Website::Page.all
    end

    # GET /website/pages/1
    def show
    end

    # GET /website/pages/new
    def new
    @website_page = Website::Page.new
    end

    # GET /website/pages/1/edit
    def edit
    end

    # POST /website/pages
    def create
    @website_page = Website::Page.new(website_page_params)

    if @website_page.save
    redirect_to @website_page, notice: 'Page was successfully created.'
    else
    render :new
    end
    end

    # PATCH/PUT /website/pages/1
    def update
    if @website_page.update(website_page_params)
    redirect_to @website_page, notice: 'Page was successfully updated.'
    else
    render :edit
    end
    end

    # DELETE /website/pages/1
    def destroy
    @website_page.destroy
    redirect_to website_pages_url, notice: 'Page was successfully destroyed.'
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_website_page
    @website_page = Website::Page.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def website_page_params
    params.fetch(:website_page, {})
    end
end
