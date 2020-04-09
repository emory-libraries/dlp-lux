$(document).on('turbolinks:load', function() {
  setExploreCollectionsHeight()
  $(window).on('resize', setExploreCollectionsHeight)
})

function setExploreCollectionsHeight() {
  if (desktopWidth(window)) {
    matchFacetsHeight()
  } else {
    setDefaultHeight()
  }
}

function desktopWidth(w) {
  return w.matchMedia("(min-width: 992px)").matches
}

function matchFacetsHeight() {
  return $('.tile-listing').css("height", $('#facet-panel-collapse').height())
}

function setDefaultHeight() {
  return $('.tile-listing').css("height", "35rem")
}