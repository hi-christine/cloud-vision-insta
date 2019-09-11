require_relative 'image_annotator_client'

# To run annotator
# Ex.
# bundle exec ruby app/run_annotator.rb "nationalportraitgallery"
# bundle exec ruby app/run_annotator.rb "ripleyandrue"
# analysis types = default, safe_search, text_search
#
# Completed
# letterfolk = text_search
# iloveny = default (but the naming of the json isn't consitent with new naming)
#
# TODO: These ones need to be analyzed or reanalyzed
# christineseeman = default
# expertvagabond = default
# myraswim = safe_search
# nationalportraitgallery = default
# nike = default
# ripleyandrue = default
# visit_nebraska = default
# visitcalifornia = default
# wolffolins = safe_search
folder_name = ARGV.first
ImageAnnotatorClient.new.traverse_folder(folder_name, ".jpg", "text_search")
