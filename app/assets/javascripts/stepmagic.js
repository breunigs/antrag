function setupKingslandingPage() {
  stepMagic();

  // bind forward/backward buttons
  $("#backbutton").click(function(obj) {
    stepMagic(-1);
    return false; // prevent form submission
  });

  $(".nextstep").click(function(obj) {
    stepMagic(+1);
    // unfortunately this is required to set their visibility for the
    // first time
    autoShowReisekostenPersonen();
    return false; // prevent form submission
  });

  // bind large, fancy action buttons
  $('div.step a.motion-selector').click(function() {
    var content = $(this).contents("b").text();
    var stepDiv = $(this).parents("div.step");
    var step = stepDiv.attr("data-step");
    var folded = $("div.folded[data-step="+step+"]")
    // update chosen text
    folded.children("span").text(content);
    stepMagic(+1);
    // update kind-input
    var x = $("#motion_kind").val().split("/");
    x[step*1-1] = content;
    $("#motion_kind").val(x.splice(0, step).join("/"));
  });

  // setup form validation
  $("form.new_motiontion").validate();

  // prevent <enter> from submitting the form without validation
  $('input,select').keydown(function(event){
    if(event.keyCode == 13) {
      event.preventDefault();
      return false;
    }
  });

  autoShowReisekostenPersonenInit();
}

// unhides more person fields as needed
function autoShowReisekostenPersonenInit() {
  $("[id^=dynamic_Finanzantrag_Reisekostenantrag_Name_]").change(function() {
    autoShowReisekostenPersonen();
  });
}

function autoShowReisekostenPersonen() {
  var show = true;
  var elm = $("[id^=dynamic_Finanzantrag_Reisekostenantrag_Name_]");

  // don't do anything if the group is not visible
  if(!elm.first().parent().parent().is(':visible'))
    return false;

  elm.each(function() {
    var empty = $(this).val().trim() == "";
    if(show || !empty)
      $(this).parent().next().andSelf().slideDown("slow");
    else
      $(this).parent().next().andSelf().slideUp("slow");

    // find first empty, then toggle show
    if(show && empty) show = false;
  });
}


// automatically shows/hides buttons and step-divs based on currentStep
function stepMagic(action) {
  if(action == +1) {
    if(!$("form.new_motion").valid()) {
      return;
    }
    currentStep++;
  } else if(action == -1)
    currentStep--;

  // try stepping first
  currentVisibleStep = [];
  stepFolding();
  // if there’s no main box visible, try to fill the gaps. For +1 we
  // know the next box will be the last one. For going back, use the
  // last one that worked
  if(currentVisibleStep.length == 0 && action == +1) {
    currentStep = 99;
    stepFolding();
  }
  if(currentVisibleStep.length == 0 && action == -1) {
    currentStep = lastKnownMaxStep;
    stepFolding();
  }

  if(currentStep != 99)
    lastKnownMaxStep = currentStep;

  if(currentStep == 1)
    $('#backbutton').hide();
  else
    $('#backbutton').show();
}

function stepFolding() {
  //console.log("Setting up for step=" + currentStep);
  // the 100 is only a safeguard
  for(i = 1; i < 100; i++) {
    var s = $("div.step[data-step="+i+"]");
    if(s.length == 0)
      continue;

    var f = $("div.folded[data-step="+i+"]");
    if(i == currentStep) { // show
       stepShowStep(s, f);
    } else if(i > currentStep) { // hide both
      stepShowNone(s, f);
    } else { // prior to current ones, show only folded
      stepShowFolded(s, f);
    }
  }
}

function stepShowNone(s, f) {
  checkAndAnimate(s, "hide");
  checkAndAnimate(f, "hide");
}

function stepShowStep(s, f) {
  checkAndAnimate(s, "show");
  checkAndAnimate(f, "hide");
}

function stepShowFolded(s, f) {
  checkAndAnimate(s, "hide");
  checkAndAnimate(f, "show");
}

// Looks if obj has a data-check attribute and sees if these
// conditions are true. If they are, the action will be executed
// on obj.
function checkAndAnimate(obj, action) {
  // loop over objects given. If there's a 2a and 2b step there
  // actually may be multiple elements.
  obj.each(function(i, obj) {
    works = true;
    // enable jquery magic
    obj = $(obj);
    // check
    if(obj.attr("data-check")) {
      //console.log(obj.attr("data-check"));
      $(obj.attr("data-check").split("&")).each(function(i, c) {
        if(!works)
          return;
        var cc = c.split("=");
        var state = $($("div.folded[data-step="+cc[0]+"] span")[0]).text();
        //console.log("   " + c + "  == " + state);
        if(state != cc[1])
          works = false;
      });
    }
    // execute
    if(works) {
      //console.log("Executing " + action + " on " + obj);
      switch(action) {
        case "hide":
          if( obj.is(":visible")) obj.slideUp("slow");
          break;
        case "show":
          if(!obj.is(":visible")) obj.slideDown("slow");
          if(obj.filter(".step").length > 0)
            currentVisibleStep += obj;
          break;
      }
    }
  });
}
