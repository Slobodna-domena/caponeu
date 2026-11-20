class PersonController < ApplicationController
  def index
    @pagination_params = {}
    @types = PersonType.where(hide_from_people_directory: [nil, false]).order(:label)
    people = Person.joins(:person_types).where(person_types: { id: @types.pluck(:id) }).distinct

    if params[:order] == "name_asc"
      @pagination_params[:order] = "name_asc"
      @filter_title = "Surname (Ascending)"
      people = people.order(last_name: :asc, first_name: :asc)
    elsif params[:order] == "name_desc"
      @pagination_params[:order] = "name_desc"
      @filter_title = "Surname (Descending)"
      people = people.order(last_name: :desc, first_name: :desc)
    elsif params[:order] == "type"
      @pagination_params[:order] = "type"
      @filter_title = "Type"
      people = people.all.sort_by { |p| [p.person_types[0], p.last_name] }.then { |a| Kaminari.paginate_array(a) }
    else
      @pagination_params[:order] = "name_asc"
      @filter_title = "Surname (Ascending)"
      people = people.order(last_name: :asc, first_name: :asc)
    end

    if params[:title].present?
      name = "%" + params[:title] + "%"
      people = people.where("unaccent(CONCAT_WS(' ', first_name, last_name)) ILIKE unaccent(?)", name)
    end
    if params[:type]
      if params[:type].present?
        people = people.joins(:person_types).where(person_types: { id: params[:type].to_i })
      end
    else
      # Historical figure default
      people = params[:title].present? ? people : people.joins(:person_types).where(person_types: { id: 3 })
    end

    people = people.where("place_of_birth ILIKE ?", "%" + params[:place_of_birth] + "%") if params[:place_of_birth].present?
    people = people.where("place_of_death ILIKE ?", "%" + params[:place_of_death] + "%") if params[:place_of_death].present?
    if params[:time_begin].present? && params[:time_end].present?
      people = people.to_a.filter {
        |person|
        (person.death_timestamp < params[:time_end].to_time.to_i &&
         person.birth_timestamp > params[:time_begin].to_time.to_i)
      }.then { |a| Kaminari.paginate_array(a) }
    end

    @people = people.page(params[:page]).per(params[:all] ? 999999 : 24)
    @site_title = "People"
  end

  def show
    @person = Person.find_by_slug(params[:id])
    if @person
      @novels = Novel.joins(:people).where("people.id = ?", @person.id)
      @materials = Material.joins(:people).where("people.id = ?", @person.id)
      @events = Event.joins(:people).where("people.id = ?", @person.id)
      @site_title = @person.full_name
    else
      check_redirect
    end
  end

  # def search
  #   @languages = [["Any", ""]] + Language.all.map { |lang| [lang.label, lang.id] }
  #   @categories = [["Any", ""]] + Category.all.map { |cat| [cat.label, cat.id] }
  #   @keywords = [["Any", ""]] + Keyword.all.map { |cat| [cat.label, cat.id] }

  #   if params[:commit]
  #     @hide_search = true
  #     session[:params] = params[:search]
  #     name = "%" + params[:search][:name] + "%"
  #     search = Person.where("people.first_name ILIKE ? OR people.last_name ILIKE ? OR CONCAT(first_name, ' ', last_name) ILIKE ?", name, name, name)
  #     if params[:search][:time_begin] != "" && params[:search][:time_end] != ""
  #       search = search.to_a.filter {
  #         |person|
  #         (person.death_timestamp < params[:search][:time_end].to_time.to_i &&
  #          person.birth_timestamp > params[:search][:time_begin].to_time.to_i)
  #       }.then { |a| Kaminari.paginate_array(a) }
  #     end
  #     @people = search.page(params[:page]).per(24)
  #   else
  #     @people = Array.new
  #   end
  # end
end
