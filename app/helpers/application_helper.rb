module ApplicationHelper
  def site_config
    YAML.load_file("config/site_config.yml")[Rails.env]
  end

  

  def cdp_shape_disco(topic)
    case topic.upcase[0, 1].ord
    when 0..71
      color = "green"
    when 72..78
      color = "orange"
    when 79..85
      color = "yellow"
    else
      color = "blue"
    end
    case topic.upcase[1, 2].ord
    when 0..71
      shape = "circle"
    when 72..78
      shape = "square"
    when 79..85
      shape = "slice"
    else
      shape = "triangle"
    end
    #color = %W(green orange blue yellow).sample
    #shape = %W(circle square slice triangle).sample
    "#{shape} #{color}"
  end

  def excluded_params
    %W(authenticity_token commit controller action order index)
  end

  def value_for(key, value)
    case key
    when "topic"
      Keyword.find(value).label
    when "category"
      Category.find(value).label
    when "language"
      Language.find(value).label
    when "type"
      MaterialType.find(value).label
    else
      value
    end
  end


  def parse_wkt_to_google_maps(wkt)
    return [] if wkt.nil? || wkt.strip.empty?

    # Handle GEOMETRYCOLLECTION by extracting the POLYGON part
    if wkt.upcase.start_with?('GEOMETRYCOLLECTION')
      # Extract the first POLYGON from the collection
      polygon_match = wkt.match(/POLYGON\s*\(\((?:[^()]|\([^)]*\))*\)\)/i)
      return [] unless polygon_match
      wkt = polygon_match[0]
    end

    # Extract all POLYGON((...)) strings, including nested parentheses
    polygons = wkt.scan(/POLYGON\s*\(\((?:[^()]|\([^)]*\))*\)\)/i)
    return [] if polygons.empty?
    
    # Process each polygon and combine all coordinates
    polygons.flat_map { |poly_wkt| parse_single_polygon(poly_wkt) }
  end
  
  

  private

  def parse_single_polygon(wkt_fragment)
    
    # Remove the POLYGON keyword and any whitespace before the coordinates
    coord_string = wkt_fragment.gsub(/^POLYGON\s*\(\(|\)\)\s*$/i, '')
    
    coordinates = coord_string.split(',')
                            .map.with_index do |coord, i|
                              parts = coord.strip.split(/\s+/).reject(&:empty?)
                              if parts.size < 2
                                next
                              end
                              
                              lng = parts[0].to_f
                              lat = parts[1].to_f
                              
                              { lat: lat, lng: lng }
                            end
                            .compact

    if coordinates.size < 3
      return []
    end
    
    coordinates
  end

  def format_matching_criteria(criteria)
    return "" if criteria.blank?
    
    parts = []
    
    if criteria[:locations]&.any?
      parts << "<span>Location</span> #{criteria[:locations].join(' • ')}"
    end
    
    if criteria[:authors]&.any?
      parts << "<span>Author</span> #{criteria[:authors].join(' • ')}"
    end
    
    if criteria[:keywords]&.any?
      parts << "<span>Topic</span> #{criteria[:keywords].join(' • ')}"
    end
    
    if criteria[:organizations]&.any?
      parts << "<span>Organization</span> #{criteria[:organizations].join(' • ')}"
    end
    
    if criteria[:events]&.any?
      parts << "<span>Historical event</span> #{criteria[:events].join(' • ')}"
    end
    
    if criteria[:people]&.any?
      parts << "<span>People</span> #{criteria[:people].join(' • ')}"
    end
    
    "<p>The map shows related novels through some of the following criteria: #{parts.join(' ')}</p>".html_safe
  end
  
end