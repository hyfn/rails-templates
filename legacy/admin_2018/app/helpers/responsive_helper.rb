module ResponsiveHelper
  # Returns an image with on-demand resizing/cropping
  #
  # @param [String] src the url of the image
  # @param [Hash] opts image manipulation options. Leave width or height blank
  #   to retain aspect ratio
  # @option opts [Integer] :w Width of the new image
  # @option opts [Integer] :h Height of the new image
  # @option opts [Integer] :quality Image quality for jpg or webp. 0-100
  # @option opts [String] :gravity If changing aspect ratio, where to crop from
  #   (north, southwest, center, etc)
  # @option opts [String] :format jpg, webp or png. Leave blank to retain
  #   current format
  def dimg_url(url, opts = {})
    opts[:w] ||= opts[:width]
    opts[:h] ||= opts[:height]
    DynamicImage.url_helper(url, opts)
  end

  def bucket_image_url(path)
    "https://#{ENV['BUCKET_CDN_HOST']}/image-assets/#{path}"
  end

  def srcset_tag(src, srcset_opts = [], tag_opts = {})
    min, srcset = srcset_attribute(src, srcset_opts)
    image_tag(min, tag_opts.merge(srcset: srcset))
  end

  def source_tag(src, options={})
    widths = [80, 120, 160, 240, 320, 480, 640, 960, 1280, 1920, 2560, 3840]

    imgopts = options.extract!(:format, :version)
    srcopts_list = widths.map {|w| imgopts.merge({ width: w })}

    if options[:crop]
      options[:media] = options[:crop][:media]

      if options[:crop][:ratio]
        srcopts_list = srcopts_list.map do |src_opts|
          {
            width: src_opts[:width],
            height: src_opts[:width] / options[:crop][:ratio],
          }
        end
      end
    end

    options.except!(:crop)

    min, srcset = srcset_attribute(src, srcopts_list)

    tag("source", options.merge(srcset: srcset))
  end

  # html <picture> tag with source tags, media, srcsets and sizes attrs
  #
  # @param [String] src the url of the image
  # @param [Hash] options image manipulation options. Leave width or height blank
  # @option options [Integer] :version version number
  # @option options [String] :format desired format
  # @option options [String] :sizes html sizes attribute, applied to all <source>'s
  # @option options [Array] :crops Array of crop hashes
  #  * @option crops [String] :media Media query breakpoint (max-width: 600px)
  #  * @option crops [Integer] :ratio Aspect ratio of crop w/h
  #
  # <%= picture_tag product_category.category_image.url,
  #   crops: [
  #     {media: '(max-width: 400px)', ratio: 1},
  #     {media: '(max-width: 700px)', ratio: 0.6}
  #   ],
  #   version: 1,
  #   format: 'png',
  #   sizes: '(min-width: 600px) 100vw, 50vw',
  #   class: 'featured-products__item-image',
  #   alt: product_category.name
  # %>
  #
  # !!important usage note!!
  #
  # crops get transformed into <source> tags.
  # A catchall <source> tag is automatically
  # added at the image's native aspect ratio,
  # so no need to specifiy a catchall.
  # If you only need default aspect ratio, don't
  # specify any crops
  #
  # browsers scan source tags from first to last
  # and use the first with a matching media attribute,
  # so order your crop array as you would source tags
  #
  # browsers scan size attributes from left to right
  # and use the first matching query
  #
  def picture_tag(src, options={})
    crops = options[:crops] || [{}]
    sizes = options[:sizes] || ''
    version = options[:version]
    fmt = options[:format]

    options.except!(:crops, :sizes, :version, :format)

    # ensure there is catchall source
    crops.push({}) if crops[crops.length - 1][:media]

    tags = crops.map do |crop|
      source_tag(src, {crop: crop, sizes: sizes, version: version, format: fmt})
    end

    tags.push(image_tag(src, options.clone.except!(:data, :class))) if src
    tags = tags.join("\n").html_safe

    content_tag("picture", tags, options)
  end

  def responsive_breakpoints(class_name, src, breakpoints = [])
    breakpoints.map do |(src_opts, query)|
      url = dimg_url(src, src_opts)
      rule = responsive_background_rule(".#{class_name}", url)
      next rule unless query

      query = "min-width: #{query}px" unless query.is_a?(String)
      responsive_background_query(query, rule)
    end.join("\n").html_safe
  end

  def responsive_image_css(class_name, src, breakpoints = [])
    css = responsive_breakpoints(class_name, src, breakpoints)
    content_for(:inline_styles, css)
    class_name
  end

  def widths_srcset(widths, options = {})
    widths.map do |w|
      { w: w }.merge(options)
    end
  end

  def retina_srcset(smallest_size, key = :w, options = {})
    (1..4).map do |multiplier|
      { key => smallest_size * multiplier, variant: "#{multiplier}x" }.merge(options)
    end
  end

  protected

  def srcset_attribute(src, srcopts_list = [])
    return [src, ''] if srcopts_list.length.zero?
    srcset_arr = srcopts_list.map do |src_opts|
      [dimg_url(src, src_opts), src_opts[:variant] || "#{src_opts[:w]}w"]
    end

    srcset = srcset_arr.map { |u, w| u + ' ' + w }.join(', ')

    [srcset_arr[0][0], srcset]
  end

  def responsive_background_rule(selector, image_url)
    <<-CSS
    #{selector} {
      background-image: url('#{image_url}');
    }
    CSS
  end

  def responsive_background_query(query, rule_css)
    <<-CSS
    @media(#{query}) {
      #{rule_css}
    }
    CSS
  end
end
