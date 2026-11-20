module HomepageHelper
  def events_for_year(year)
    Event.where.not(hide_from_timeline: true).
      where("EXTRACT(YEAR FROM started) = ? OR EXTRACT(YEAR FROM ended) = ?", year, year).
      order("started asc")
  end
end
