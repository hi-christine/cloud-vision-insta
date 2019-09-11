require_relative 'image_annotator_client'

# To run annotator
# Ex.
# bundle exec ruby app/batch_run_annotator.rb
# analysis types = default, safe_search, text_search
#
# Completed
# letterfolk = text_search
## christineseeman = default
# expertvagabond = default
# myraswim = safe_search
# nationalportraitgallery = default
# nike = default
# ripleyandrue = default
# # visit_nebraska = default
# # visitcalifornia = default
# # wolffolins = safe_search
# # iloveny
# TODO: These ones need to be analyzed or reanalyzed
# all done
# ImageAnnotatorClient.new.delete_analysis_folder("christineseeman", "face_detection_label_detection_landmark_detection_and_logo_detection")
# ImageAnnotatorClient.new.traverse_folder("christineseeman")
# ImageAnnotatorClient.new.delete_analysis_folder("expertvagabond", "label_and_face")
# ImageAnnotatorClient.new.traverse_folder("expertvagabond")
# ImageAnnotatorClient.new.traverse_folder("myraswim", ".jpg", "safe_search")
# ImageAnnotatorClient.new.traverse_folder("nationalportraitgallery")
# ImageAnnotatorClient.new.delete_analysis_folder("nike", "label_and_face")
# ImageAnnotatorClient.new.traverse_folder("nike")
# ImageAnnotatorClient.new.delete_analysis_folder("ripleyandrue", "label_face_landmark_and_logo")
# ImageAnnotatorClient.new.traverse_folder("ripleyandrue")
# ImageAnnotatorClient.new.delete_analysis_folder("visit_nebraska", "label_landmark_and_face")
# ImageAnnotatorClient.new.traverse_folder("visit_nebraska")
# ImageAnnotatorClient.new.delete_analysis_folder("visitcalifornia", "label_landmark_and_face")
# ImageAnnotatorClient.new.traverse_folder("visitcalifornia")
# ImageAnnotatorClient.new.delete_analysis_folder("wolffolins", "label_and_face")
# ImageAnnotatorClient.new.traverse_folder("wolffolins", ".jpg", "safe_search")
# ImageAnnotatorClient.new.delete_analysis_folder("iloveny", "label_face_landmark_and_logo")
# ImageAnnotatorClient.new.traverse_folder("iloveny")