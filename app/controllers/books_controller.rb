class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction

  # GET /books
  # GET /books.json
  def index
    @tasks = if params[:toSearch]
      @books = Book.search(params[:toSearch]).paginate(:page => params[:page], :per_page => 5)
    else
      @books = Book.order("#{sort_column} #{sort_direction}").paginate(:page => params[:page], :per_page => 5)
    end
  end

  # GET /books/1
  # GET /books/1.json
  def show
  end

  # GET /books/new
  def new
    @book = Book.new
    @genres = Genre.all.order(:name)
    @authors = Author.all.order(:lastname)
  end

  # GET /books/1/edit
  def edit
    @genres = Genre.all.order(:name)
    @authors = Author.all.order(:lastname)
  end

  # POST /books
  # POST /books.json
  def create
    @book = Book.new(book_params)
    @genres = Genre.all.order(:name)
    @authors = Author.all.order(:lastname)

    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: 'Book was successfully created.' }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
    @genres = Genre.all.order(:name)
    @authors = Author.all.order(:lastname)

    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url, notice: 'Book was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_params
      params.require(:book).permit(:title, :author_id, :genre_id, :year, :description)
    end

    def sort_column
      params[:sort] || "title"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end
