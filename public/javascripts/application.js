// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
// Toggle TinyMCE
function toggleEditor(id){

	if (!tinyMCE.get(id)) {
		tinyMCE.execCommand('mceAddControl', false, id);
	}
	else {
		tinyMCE.execCommand('mceRemoveControl', false, id);
	}
}	
