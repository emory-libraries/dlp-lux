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
  if ($('#facet-panel-collapse').height() < 560) {
    setDefaultHeight()
  } else {
    return $('.tile-listing').css("height", $('#facet-panel-collapse').height())
  }
}

function setDefaultHeight() {
  return $('.tile-listing').css("height", "35rem")
}