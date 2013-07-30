# Require any additional compass plugins here.
project_type = :rails


# steve this is old stuff from LA


# This configuration file works with both the Compass command line tool and within Rails.
# Require any additional compass plugins here.
#project_type = :rails
project_path = Rails.root if defined?(Rails)
# Set this to the root of your project when deployed:
http_path = "/"

# Where do you want the outputted css to appear?
css_dir = "./public/stylesheets"

# Where do you want the sass to stay?
sass_dir = "./app/assets/stylesheets"

# Add "compressed" if you want a smaller css outputted file (other options include: :nested, :expanded, :compact, or :compressed ///// http://compass-style.org/docs/tutorials/configuration-reference)
output_style      = :expanded            # CSS is nice and compact

# Add "False" if you want a smaller css outputted file, true make your css output have comments
line_comments = true

# Where are the fonts in your app?
http_font_path    = "/public/fonts/"              # font face 

# Where are the images in your app?
http_image_path    = "/images/2010/"              

# To enable relative paths to assets via compass helper functions. Uncomment:
# relative_assets = true

# Need more help?
# Learn more about configuration at http://compass-style.org/docs/tutorials/configuration-reference
# Google Group http://groups.google.com/group/compass-users
