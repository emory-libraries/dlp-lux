# frozen_string_literal: true

PARENT_WORK_WO_COLLECTION_ATTACHED = {
  id: '1010110',
  has_model_ssim: ['CurateGenericWork'],
  title_tesim: ['Random Work'],
  thumbnail_path_ss: ['/downloads/1010110?file=thumbnail'],
  edit_access_group_ssim: ["admin"],
  read_access_group_ssim: ["public"],
  visibility_ssi: ['open'],
  visibility_group_ssi: "Public",
  human_readable_visibility_ssi: "Public",
  child_works_for_lux_tesim: [
    "1010111, /downloads/1010111?file=thumbnail, This Doc"
  ]
}.freeze

CHILD_WORK_WO_COLLECTION_ATTACHED = {
  id: '1010111',
  has_model_ssim: ['CurateGenericWork'],
  title_tesim: ['A Masterpiece'],
  thumbnail_path_ss: ['/downloads/1010111?file=thumbnail'],
  edit_access_group_ssim: ["admin"],
  read_access_group_ssim: ["public"],
  visibility_ssi: ['open'],
  visibility_group_ssi: "Public",
  human_readable_visibility_ssi: "Public",
  parent_work_for_lux_tesim: ["1010110, Random Work"]
}.freeze
