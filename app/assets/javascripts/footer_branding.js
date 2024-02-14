const redirect = selectObject => {

  const selection = selectObject.value;

  // Ignore empty selections.
  if(selection == null || selection === '') return;

  // Get the location of the targeted site.
  const href = selection.startsWith('http://') || selection.startsWith('https://') ? selection : `${selection}`;

  // Redirect the site to the target location.
  window.location.href = href;

}
