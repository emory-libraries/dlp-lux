# frozen_string_literal: true

module DefaultExploreCollections
  def stub_default_explore_collections
    ExploreCollection.find_or_create_by(
      title: 'Health Sciences Center Library Artifact Collection',
      banner_path: 'https://curate.library.emory.edu//branding/5053ffbg7n-cor/banner/HS-S023_B067_P004.jpg',
      collection_path: 'https://digital.library.emory.edu/catalog/5053ffbg7n-cor',
      description: "Contains a wide selection of medical instruments including surgical instruments, physician's medicine bags, scales, tourniquets, scarifier sets, and other instruments dating from 1832 to 2000.",
      active: true
    )

    ExploreCollection.find_or_create_by(
      title: 'Robert Langmuir African American Photograph Collection',
      banner_path: 'https://curate.library.emory.edu//branding/914nk98sfv-cor/banner/40644j0ztx-cor.jpg',
      collection_path: 'https://digital.library.emory.edu/catalog/914nk98sfv-cor',
      description: 'Collection of photographs depicting African American life and culture collected by Robert Langmuir.',
      active: true
    )

    ExploreCollection.find_or_create_by(
      title: 'Oxford College Collection of Asian Artifacts',
      banner_path: 'https://curate.library.emory.edu//branding/320sqv9s4v-cor/banner/OXKOBE_045_P0001.jpg',
      collection_path: 'https://digital.library.emory.edu/catalog/320sqv9s4v-cor',
      description: 'Contains a variety of Japanese, Korean, and Chinese artifacts, most of them purchased in Kobe, Japan by William Patillo Turner while he was a member of the Japan Mission of the United Methodist Church, South.',
      active: true
    )
  end
end
