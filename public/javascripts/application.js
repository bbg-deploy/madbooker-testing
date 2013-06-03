var SLIDE_SPEED = 500


var changed = '';



//tog
function tog(clicker, toggler, callback, speed){
  if (speed == undefined) {speed = SLIDE_SPEED;}
  if (callback) {$(clicker).click(function(){$(toggler).slideToggle(speed, callback); return false;});}
  else {$(clicker).click(function(){$(toggler).slideToggle(speed); return false;});}
  

}
function togger(j, callback, speed){
  if (speed == undefined) {speed = SLIDE_SPEED}
  if(callback) {$(j).slideToggle(speed, callback); }
  else {$(j).slideToggle(speed); }
}

function toggle_this(caller, to_tog){
  togger(to_tog);
  var text = $(caller).html();
  if (text == 'show iteration' || text == 'hide iteration') {
    if ($(caller).html() == 'show iteration') {$(caller).html('hide iteration')}
    else {$(caller).html('show iteration')}
  }
  if (text == 'show' || text == 'hide') {
    if ($(caller).html() == 'show') {$(caller).html('hide')}
    else {$(caller).html('show')}
  }
  else if (text == 'Show' || text == 'Hide') {
    if ($(caller).html() == 'Show') {$(caller).html('Hide')}
    else {$(caller).html('Show')}
  }
  else {
    if ($('img', caller).attr('src') == "/images/hide.png") {$('img', caller).attr('src', "/images/show.png")}
    else {$('img', caller).attr('src', "/images/hide.png")}
  }
}

$.fn.togger = function(){
  return this.each(function(){
    $(this).slideToggle(SLIDE_SPEED); 
  })
}

$.fn.shower = function(){
  return this.each(function(){
    if ($(this).is(':hidden')){ $(this).togger()}
  })
}
$.fn.hider = function(){
  return this.each(function(){
    if (!$(this).is(':hidden')){ $(this).togger()}
  })
}
//tog








jQuery.fn.center = function(){
  return this.each(function(){
    var win = $(window).width();
    var width = jQuery(this).width();
    $(this).css({width: width +'px', left: (win/2 - width/2) + 'px'});
  })
}







//message
function async_message(m, d){message(m, d);}
function msg(m, d){message(m, d);}
function messages(m, d){message(m, d);}
function message(message, duration){
    if (duration == undefined){ duration = 3000;}
    if ($.browser.msie) { $("#message").css({position: 'absolute'}); }
    $("#message").text(message).show().center();
    setTimeout('$("#message").hide()',duration);
    return false;
}
//message


function debug(m){if (typeof console != 'undefined'){console.log(m);}}
function puts(m){debug(m);}







$.fn.infinite_uploads = function(options){
  var settings = {id_frg: "", name_frag: "", num: 0, x_id: "", type: "image", thing: 'picture'}
  $.extend(settings, options);
  function make_upload(a, settings){
    var b = settings.id_frag, c = settings.name_frag, d = settings.num;
    var e = settings.x_id, f = settings.type, g = settings.thing;
    a.append('<div id="upload_div_file' + d + '" class="'+ f +'"><input id="' + b + '_'+ f +'s_attributes_' +   d + '_'+ g +'" name="' + c + '['+ f +'s_attributes][' +   d + ']['+ g +']" class="infinite_upload' + e + '" type="file" /><a class="cancel_upload_link" onclick="clearFileInputField(\'upload_div_file' + d + '\')" href="javascript:void(0);">Clear</a></div>');
    hide_cancel_links();
    settings.num++;
  }
  $(".infinite_upload" + settings.x_id).live('change', function(){
    make_upload($(this).parent().parent(), settings);
  })
  var xxx = this;
  return this.each(function(){  make_upload($(xxx), settings);})
}



function datepicker_init(){
  $('.datepicker').datepicker({
  	changeMonth: true,
  	changeYear: true,
  	showAnim: 'blind',
  	showButtonPanel: true,
  	dateFormat: DATE_FORMAT
  });
  $('.datepicker_birthdate').datepicker({
  	changeMonth: true,
  	changeYear: true,
  	showButtonPanel: true,
  	dateFormat: DATE_FORMAT,
        yearRange: '1900:2020'
  });
}








//startup
$(function(){
	jQuery("#waiter").ajaxStart(function(){$(this).show();}).ajaxStop(function(){$(this).hide();}).ajaxError(function(){$(this).hide();});
	
  
  $('#business_select').bind('change.change_business', function(){
   var sel = $(this);
   window.location = sel.val()
  });
	
	
})
//startup

