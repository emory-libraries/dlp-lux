# frozen_string_literal: true
module AboutThisItemHelper
  def resolution_download_restriction(document)
    if document['visibility_ssi'] == 'low_res'
      "<p class='resolution-download-restriction'>
        #{t('blacklight.work.about_this_item.low_resolution')} #{t('blacklight.work.about_this_item.downloads')}
      </p>"
    elsif document['visibility_ssi'] == 'emory_low'
      "<p class='resolution-download-restriction'>
        #{t('blacklight.work.about_this_item.low_resolution')}
      </p>"
    end
  end
end
