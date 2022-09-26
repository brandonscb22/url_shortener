class LinksController < ApplicationController
  before_action :set_link, only: %i[ show edit update destroy ]

  # GET /links or /links.json
  def index
    @links = Link.select("links.id as id, links.title as title, links.description as description, links.url as url, links.short_code as short_code, links.alexa_rank as alexa_rank, count(link_histories.id) as visits")
                 .joins('LEFT JOIN link_histories ON link_histories.link_id = links.id')
                 .group("links.id, links.title, links.description, links.url, links.short_code, links.alexa_rank")
    @base_url = request.host_with_port
    respond_to do |format|
      format.html { render :index, links: @links, base_url: @base_url }
      format.json { render json: @links }
    end
  end

  # GET /links/1 or /links/1.json
  def show
    @base_url = request.host_with_port
    @link_histories = LinkHistory.where(link: @link)
    respond_to do |format|
      format.html { render :show, link: @link, link_histories: @link_histories, base_url: @base_url }
      format.json { render json: { link:@link,link_histories: @link_histories} }
    end
  end

  # GET /links/new
  def new
    @link = Link.new
  end

  # GET /links/1/edit
  def edit
  end

  # POST /links or /links.json
  def create
    puts link_params
    @link = Link.new(link_params.merge(short_code: generate_link))
    @base_url = request.host_with_port
    @base_url_protocol = request.protocol
    respond_to do |format|
      if @link.save
        @alexa_rank = AlexaRank.new(url: link_params['url']).consult_ranking
        @link.alexa_rank = @alexa_rank
        @link.save
        format.html { redirect_to links_path, notice: "Link was successfully created." }
        format.json { render :show, status: :created, location: @link }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /links/1 or /links/1.json
  def update
    if @link.present?
      @base_url = request.host_with_port
      @base_url_protocol = request.protocol
      respond_to do |format|
        if @link.update(link_params)
          format.html { redirect_to links_path, notice: "Link was successfully updated." }
          format.json { render :show, status: :ok, location: @link }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @link.errors, status: :unprocessable_entity }
        end
      end
    else
      puts 'yes'
      respond_to do |format|
        format.html { render :index }
        format.json { render json: {message: 'Link not found'}, status: :not_found }
      end
    end

  end

  # DELETE /links/1 or /links/1.json
  def destroy
    @link.destroy
    respond_to do |format|
      format.html { redirect_to links_url, notice: "Link was successfully destroyed." }
      format.json { render json: { message: 'Deleted OK' } }
    end
  end

  # GET /short_code
  def short_code
    @link = Link.find_by(short_code:params[:short_code])
    browser = Browser.new(request.headers['User-Agent'], accept_language: request.headers["Accept-Language"])
    link_history = LinkHistory.new do |lh|
      lh.link = @link
      lh.ip = request.remote_ip
      lh.browser = browser.name
      lh.platform = browser.platform
    end
    link_history.save
    redirect_to @link.url, allow_other_host: true
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_link
      @link = Link.where(id: params[:id]).first
    end

    # Only allow a list of trusted parameters through.
    def link_params
      params.require(:link).permit(:title, :description, :url, :short_code, :alexa_rank)
    end

    def generate_link
      SecureRandom.alphanumeric(8)
    end
end
