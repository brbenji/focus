::  design issues
::    goals text is squished on mobile bc of the ownership pop-up
::      (can't do a lot about that)
::    times in goals are in utc. that's lame but we don't know how to
::      get the local timezone yet.
::
/-  *focus
/+  rudder
::
^-  (page:rudder tack command)
|_  [=bowl:gall =order:rudder tack]
::
++  final  (alert:rudder (cat 3 '/' dap.bowl) build)
::
++  argue
  |=  [headers=header-list:http body=(unit octs)]
  ^-  $@(brief:rudder command)
  =/  args=(map @t @t)  ?~(body ~ (frisk:rudder q.u.body))
  ::
  ?:  (~(has by args) 'pause')
    [%pause &]
  ?:  (~(has by args) 'cont')
    [%cont &]
  ?:  (~(has by args) 'goals')
    ?:  =((~(got by args) 'goals') 'on')
      [%goals &]
    [%goals |]
  ?:  |((~(has by args) 'begin') (~(has by args) 'nav'))
    ?:  (~(has by args) 'multi')
      ::  multi will reveal the hidden rest inputs
      ::
      [%multi &]
    ?:  =((~(got by args) 'nav') 'new')
      ::  return to form for a new groove
      ::
      [%maneuver groove (display.focus %form)]
    ?:  =((~(got by args) 'nav') '?')
      ::  allows my submit button value to be ? and not help
      ::
      [%maneuver groove (display.focus %help)]
    ?:  =((~(got by args) 'nav') 'X')
      ::  exit help
      ::
      [%maneuver groove (display.focus %form)]
    ?.  (~(has by args) 'h')
      ::  the time setting code below won't work unless nav produces h m s etc
      ::    this produces the existing groove instead
      ::
      [%maneuver groove (displayify (slav %tas (~(got by args) 'nav')))]
    ::  this creates "~h0.m0.s0"
    ::    converting null to '0'
    ::
    =/  f-time  ^-  tape
    :~  '~h'
        ?~(h=(~(got by args) 'h') '0' h)
        '.m'
        ?~(m=(~(got by args) 'm') '0' m)
        '.s'
        ?~(s=(~(got by args) 's') '0' s)
    ==
    =/  r-time  ^-  tape
    :~  '~h'
        ?~(rh=(~(got by args) 'rh') '0' rh)
        '.m'
        ?~(rm=(~(got by args) 'rm') '0' rm)
        '.s'
        ?~(rs=(~(got by args) 'rs') '0' rs)
    ==
    ::  also calc wrap to focus time diff
    ::    and grab pos: of strokedashoff
    ::
    =/  focus  `@dr`(slav %dr (crip f-time))
    =/  wrap  `@ud`(slav %ud (~(got by args) 'wrap'))
    =/  reps  `@ud`(slav %ud ?~(num=(~(got by args) 'reps') ?.(multi '1' '2') num))
    =/  rest  `@dr`(slav %dr (crip r-time))
    ::  wrep is just a copy of wrap for now
    ::  =/  wrep  `@ud`(slav %ud (~(got by args) 'wrep'))
    ::
    =/  wrep  wrap
    ::
    [%maneuver (gruv [focus wrap reps rest wrep]) (displayify %clock)]
  ~
::
++  build
  |=  $:  arg=(list [k=@t v=@t])
          msg=(unit [o=? =@t])
      ==
  ^-  reply:rudder
  |^  [%page page]
  ++  page
    ^-  manx
    ;hmtl
    ;head
      ;title:"%focus"
      ;link(rel "icon", type "image/png", href "focus/assets/tile/png");
      ;meta(charset "utf-8");
      ;meta(name "viewport", content "width=device-width, initial-scale=1");
      ;style:"{(weld (trip style) mod-style)}"
      ;script:"{script}"
    ==
    ;body
    ;+
    ?:  =(display %clock)
      ;div#wrapper
        ;audio.hide(controls "", autoplay "")
          ;+
          ?:  =(prev-cmd %pause)
            ::  recycling the help sound for pause
            ::
            ;source(src "focus/assets/help/wav", type "audio/wav");
          ?:  &(=(mode %focus) (gte reps 2))
            ::  a late decision swapped the sfx for rest and focus. sry.
            ::
            ;source(src "focus/assets/rest/wav", type "audio/wav");
          ?:  =(mode %rest)
            ;source(src "focus/assets/focus/wav", type "audio/wav");
          ;source(src "focus/assets/begin/wav", type "audio/wav");
        ==
        ;div.clock
          ;div.face.brothers
            ;form.brothers(method "post")
              ;+  ?:  =(prev-cmd %pause)
                  ::  if the previous command was %pause change to cont
                  ::  and add a [new] button
                    ;div
                      ;input.pause(type "submit", name "cont", value "cont");
                      ;input.new.brothers.reveal(type "submit", name "nav", value "new");
                    ==
                  ;input.pause(type "submit", name "pause", value "pause");
            ==
            ;svg.brothers.reveal(viewbox "0 0 100 100")
              ;circle#wipe(cx "50", cy "50", r "3em");
            ==
            ;svg#wrap-icon.brothers.reveal(viewbox "0 0 100 100")
              ;polygon(style "fill:white", points "{(~(got by wrap-icon) wrap.groove)}");
            ==
            ;+
            ?:  =(mode %rest)
              ;div.time-rest.brothers
                ;strong.time(style "font-size: 2.33em"): {(face rest.groove)}
                ;strong#rest: rest
                ;+  ?:  =(prev-cmd %pause)  ;div;
                    ;p#rep-count(style "top: 3em; left: 2.8em"): {<reps>} of {<reps.groove>}
              ==
            ?.  multi  ;strong.time.brothers: {(face focus.groove)}
            ;div.brothers
              ;strong.time: {(face focus.groove)}
              ;+  ?:  =(prev-cmd %pause)  ;div;
                  ;p#rep-count: {<reps>} of {<reps.groove>}
            ==
          ==
        ==
        ;div.footer
          ;p#total: {total}
          ;form#help.hide(method "post", autocomplete "off")
            ;input#help-qm.transparent(type "submit", name "nav", value "?");
          ==
          ;+  ?:  =(mode %rest)
                ;audio#wrep-wav.hide(controls "")
                  ;source(src "focus/assets/wrep/wav", type "audio/wav");
                ==
              ;audio#wrap-wav.hide(controls "")
                ;source(src "focus/assets/wrap/wav", type "audio/wav");
          ==
        ==
      ;+  ?.  on.goals  ;div;
        ;iframe(src "apps/gol-cli/", style "margin-top: 3em;", width "100%", height "550em");
      ==
    ?:  =(display %form)
      ;div#wrapper
        ;audio.hide(controls "", autoplay "")
          ;+  ?:  multi  ;source(src "focus/assets/reps/wav", type "audio/wav");
            ;source(src "focus/assets/form/wav", type "audio/wav");
        ==
        ;div#form-display.clock
          ;form.set.reveal(method "post", autocomplete "off")
            ;strong.label: focus
            ;input(type "number", name "h", placeholder "h", min "0");
            ;input(type "number", name "m", placeholder "m", min "0");
            ;input(type "number", name "s", placeholder "s", min "0");
            ;input.range(type "range", name "wrap", id "wrap", min "5", max "9", value "{<wrap.groove>}", oninput "percent.value=wrap.valueAsNumber + '0%'");
            ;output(name "percent", for "wrap");
            ;+  ?.  multi  ;div;
              ;strong.label: rest
            ;input(type "{reveal-rest}", name "rh", placeholder "h", min "0");
            ;input(type "{reveal-rest}", name "rm", placeholder "m", min "0");
            ;input(type "{reveal-rest}", name "rs", placeholder "s", min "0");
            ;input.range(type "hidden", name "wrep", min "5", max "9", value "{<wrep.groove>}");
            ;input(type "hidden", name "nav", value "clock");
            ;input#reps(type "{reveal-rest}", name "reps", placeholder "x2", min "1");
            ;+  ?:  multi  ;div;
              ;input#reps-btn(type "submit", name "multi", value "x2");
            ;input#begin(type "submit", name "begin", value ">");
          ==
          ;label.switch.reveal
            ;+  ?.  on.goals
              ::  goals aren't on. display unchecked
              ::  tell goals to turn on when clicked
              ::
              ;form(method "post", id "goalsToggle")
                ;input(type "checkbox", onchange "goalsToggle()");
                ;span.slider;
                ::  hidden inputs are required to pass in args
                ;input(type "hidden", name "goals", value "on");
              ==
            ::  goals on. display checked
            ;form(method "post", id "goalsToggle")
              ;input(type "checkbox", checked "", onchange "goalsToggle()");
              ;span.slider;
              ;input(type "hidden", name "goals", value "off");
            ==
          ==
        ==
        ;div.footer
          ;form#help(method "post")
            ;input#help-qm(type "submit", name "nav", value "?");
          ==
        ==
        ;+  ?.  on.goals  ;div;
          ;iframe(src "apps/gol-cli/", style "margin-top: 3em;", width "100%", height "550em");
      ==
    ?:  =(display %help)
      ;div#wrapper
        ;audio.hide(controls "", autoplay "")
          ;source(src "focus/assets/help/wav", type "audio/wav");
         ==
        ;div.clock.help
          ;strong#title: an interval timer
          ;p.sm.bold: focus
          ;p.sm: set a time for flow
          ;input#range-help(type "range", min "5", max "9", value "8");
          ;p.sm: receive a wrap-up call
          ;p.sm.bold: rest
          ;p.sm: relax a moment
          ;input#btn-help(type "submit", value "x2");
          ;p.sm: focus more than once
          ;label#switch-help.switch
            ;input(type "checkbox", name "goals", value "on");
            ;span.slider;
          ==
          ;p.sm: connect with %goals
        ==
        ;div.footer
          ;form#help(method "post")
            ;input#help-x(type "submit", name "nav", value "X");
          ==
        ==
      ==
    ::  display enter
    ::
    ;div#wrapper
      ;audio.hide(controls "", autoplay "")
        ;source(src "focus/assets/enter/wav", type "audio/wav");
      ==
      ;div#enter.clock
        ;form.brothers(method "post")
          ;input.to-form(type "submit", name "nav", value "form", autofocus "");
        ==
        ;div.face.brothers
          ;svg.brothers(viewbox "0 0 100 100")
            ;circle#enter(cx "50", cy "50", r "3em");
          ==
          ;svg#wrap-icon.brothers(viewbox "0 0 100 100")
            ;polygon(style "fill:white", points "{(~(got by wrap-icon) 9)}");
          ==
          ;strong#focus.time.brothers: focus
        ==
      ==
      ;div.footer;
      ;+  ?.  on.goals  ;div;
        ;iframe(src "apps/gol-cli/", style "margin-top: 3em;", width "100%", height "550em");
    ==
    ==  ==
  ::
  ::  "THIS CODE KILLS 99.99% OF JAVASCRIPT"
  ::  location.reload(), localStore(), submit(), and play() are so
  ::  far what I need from js
  ::
  ++  script
    """
    function goalsToggle() \{
      document.getElementById("goalsToggle").submit();
    };

    setTimeout(() => \{
      document.getElementById({<?:(=(mode %rest) "wrep-wav" "wrap-wav")>}).play();
    }, {handle-wrap});

    setTimeout(() => \{
      document.location.reload();
    }, {handle-refresh});
    """
  ::  helper arms for dynamically changing
  ::    +script, +mod-style, +build
  ::
  ++  reveal-rest
    ?:  multi
      "number"
    "hidden"
  ++  mode-switch
    ^-  @dr
    ?:(=(mode %rest) rest.groove focus.groove)
  ++  time-left
    ^-  @dr
    ?:  (lte -.then now.bowl)
      mode-switch
    (sub -.then now.bowl)
  ++  wrap-left
    ^-  @dr
    ?:  (lte +.then now.bowl)
      ~s0
    (sub +.then now.bowl)
  ++  left-to-wipe
    ::  left/focus.groove = x/315
    ::  x = (left * 315)/focus.groove
    ::
    |=  left=@dr
    ^-  tape
    :: need a null protection here (bc using div)
    ::
    ?~  left  "315"
    =/  wipe-amount  (div (mul left 315) mode-switch)
    (a-co:co wipe-amount)
  ++  face
    ::  turn the numbers on the clock from @dr
    ::  to something more normie readable
    ::
    |=  rel=@dr
    ^-  tape
    =/  sec  (yell rel)
    =/  total  (add (mul hor:yo h.sec) (add (mul mit:yo m.sec) s.sec))
    =/  min  (div total 60)
    ::  account for times less than a minute
    ::  display seconds instead
    ::
    ?:  (lte total 60)
      (weld (a-co:co total) "s")
    (weld (a-co:co min) "m")
  ++  wrap-icon
    ::  a map connecting wrap to five different points
    ::  for creating the wrap-icon with a polygon svg
    ::
    =;  icon  `(map wrap tape)`icon
    %-  malt
    :~  [9 "100,25 100,33 76,37"]
        [8 "75,0 84,0 64,22"]
        [7 "47,0 39,0 46,24"]
        [6 "5,0 0,6 20,24"]
        [5 "0,39 0,46 27,47"]
    ==
  ++  total
    ^-  tape
    =/  sets  ?~(reps.groove 1 reps.groove)
    =/  f-total  (mul focus.groove sets)
    =/  r-total  (mul rest.groove (dec sets))
    =/  total  `@dr`(add f-total r-total)
    "{<total>}"
  ++  duration
    |=  rel=@dr
    ^-  tape
    ::  yell produces [d= h= m= s=] from @dr
    ::
    =/  sec  (yell rel)
    =/  total  (add (mul hor:yo h.sec) (add (mul mit:yo m.sec) s.sec))
    =/  total-ms  (mul total 1.000)
    (a-co:co total-ms)
  ++  handle-refresh
    ::  make sure display is clock and time isn't paused
    ::
    ?:  &(=(display %clock) ?!(=(prev-cmd %pause)))
        ::  one second delay to insure the behn timers
        ::  have completed and their effects propagated
        ::
        (duration (add time-left ~s1))
    ::  (a-co:co day:yo) sounds like poetry but
    ::  it's just a day in seconds in a tape "86460"
    ::
    (a-co:co (mul day:yo 1.000))
  ++  handle-wrap
    ^-  tape
    =/  ms-day  (a-co:co (mul day:yo 1.000))
    ?:  &(=(display %clock) ?!(=(prev-cmd %pause)))
      ?:  =(wrap-left ~s0)
        ms-day
      ::  add a quarter second delay to sync
      ::  the wrap play with animation
      ::
      (duration (add wrap-left ~s0..4000))
    ms-day
  ::  mod-style is built in a tape for code insertion
  ::
  ++  mod-style
    """
    #begin \{
      grid-column-end: 3;
      grid-row: {<?.(multi 3 7)>};
      height: 2.33em;
      width: 3em;
      position: relative;
      top: {?:(multi "1.45" "7.1")}em;
      left: .55em;
      border: 0.09em solid rgb(60,60,60);
      border-radius: 0.33em;
    }
    .clock \{
      display: grid;
      place-items: center;
      grid-template-rows: auto;
      margin: 1em;
      padding: .66em;
      border: .09em solid black;
      border-radius: .66em;
      height: 11em;
      width: 11em;
      scale: 2;
      overflow: hidden;
      background-color: {?:(=(prev-cmd %pause) "black" "white")};
    }
    .set \{
      display: grid;
      grid-template-columns: 2.8em 3.1em 2.8em;
      grid-template-rows: {?:(multi "repeat(3, 1.33em) 1em repeat(3, 1.33em)" "repeat(4, 1.33em)")};
      grid-gap: .33em;
      accent-color: dimgray;
      margin-right: -.33em;
    }
    circle \{
      stroke: {?:(=(prev-cmd %pause) "white" "black")};
      fill: none;
      stroke-width: 6em;
      stroke-dasharray: 314; /* equal to circumference of circle 2 * 3.14 * 50 */
      stroke-dashoffset: 201; /* initial setting */
      filter: blur(.04em);
      animation: wipe {?:(=(mode %rest) (duration rest.groove) (duration focus.groove))}ms infinite linear;
    }
    @keyframes wipe \{
      0% \{
        stroke-dashoffset: {(left-to-wipe time-left)};
      }
      100% \{
        /* on pause, freeze the wipe effect */
        stroke-dashoffset: {?:(=(prev-cmd %pause) (left-to-wipe time-left) "0")};
      }
    }
    #enter \{
      animation: enter 2.5s;
    }
    @keyframes enter \{
      0% \{
        opacity: 0;
        stroke-dashoffset: 221;
      }
      100% \{
        opacity: 1;
        stroke-dashoffset: 201;
      }
    }
    """
  ::
  ++  style
    '''
    * {
      margin: 0;
      box-sizing: border-box;
    }
    body {
      font-family: Times, Times New Roman, serif;
    }
    input[type="number"]::-webkit-inner-spin-button,
    input[type="number"]::-webkit-outer-spin-button {
      -webkit-appearance: inner-spin-button;
      appearance: inner-spin-button;
    }
    svg {
      transform: rotate(-90deg);
      scale:2;
    }
    input {
      font-weight: 700;
      cursor: pointer;
      font-family: Arial, Helvetica, sans-serif;
    }
    p {
      place-self: start;
    }
    output {
      grid-row: 3;
      grid-column: 1;
      position: relative;
      scale: .8;
      place-self: center;
      top: .33em;
      left: .5em;
      color: dimgray;
      animation: enter 1s;
      height: 0em;
    }
    .transparent {
      opacity: 0;
    }
    .sm {
      font-size: .66em;
    }
    .bold {
      font-weight: bold;
      justify-self: center;
    }
    .reveal {
      animation: enter 1s;
    }
    .hide {
      visibility: hidden;
    }
    .clock.help {
      grid-template-columns: 2.66em auto;
      grid-template-rows: 2em repeat(5, 1.1em);
      grid-gap: .33em;
    }
    .time {
      font-size: 3em;
      color: white;
      mix-blend-mode: difference;
      position: relative;
      left: .05em;
    }
    .time-rest {
      margin-left: .33em;
    }
    .label {
      grid-column: 1/span 4;
      place-self: center;
      margin-top: .2em;
    }
    .range {
      grid-column: 1/span 3;
      grid-row: 3;
      scale: .75;
    }
    .pause {
      height: 5em;
      width: 8em;
      position: relative;
      z-index: 1;
      opacity: 0;

      display: grid;
      place-content: center;
      scale: 2;
      margin-right: -.5em;
    }
    .face {
      display: grid;
      place-items: center;
    }
    .to-form {
      height: 5em;
      width: 8em;
      position: relative;
      z-index: 1;
      opacity: 0;
    }
    .new {
      height: 2em;
      width: 3em;
      position: relative;
      z-index: 1;
      top: 2.8em;
      right: -6.5em;
      mix-blend-mode: difference;
      background-color: black;
      border-radius: .33em;
      border: solid .09em whitesmoke;
      color: white;
      scale: .66;
      transition: .3s ease-in-out;
    }
    .new:hover {
      background-color: #333;
      border: solid 1px white;
      color: white;
    }
    .brothers {
      grid-row: 1;
      grid-column: 1;
    }
    .footer {
      margin-top: 2em;
      width: 22em;
    }
    #wrapper {
      display: grid;
      place-items: center;
      grid-template-rows: 6em 20em 7em auto;
      grid-gap: 1em;
      height: 100vh;
    }
    #wrap-icon {
      filter: blur(.03em);
      mix-blend-mode: difference;
    }
    #form-display {
      overflow: visible;
    }
    #reps {
      grid-column: 3;
      height: 1.75em;
      position: relative;
      top: 0.2em;
    }
    #reps-btn {
      grid-column: 3;
      height: 1.75em;
      position: relative;
      top: 2em;
      color:dimgrey;
    }
    #rep-count {
      display: flex;
      justify-content: flex-end;
      height: 0em;
      position: relative;
      top: 2.66em;
      left: 2.8em;
      color: rgb(225, 225, 225);
      mix-blend-mode: difference;
      scale: .66;
    }
    #rest {
      display: flex;
      justify-content: center;
      color: rgb(225, 225, 225);
      mix-blend-mode: difference;
      height: 0em;
      font-weight: 500;
    }
    #help {
      display: grid;
      place-content: center;
      height: 0em;
      scale: 2;
      margin-right: -.5em;
    }
    #help-qm {
      border-radius: 1em;
      border-style: solid;
      width: 2em;
      height: 2em;
      place-self: end;
      position: relative;
      top: -1.5em;
      left: 5em;
      color: dimgrey;
      scale:.8;
    }
    #help-x {
      border-radius: 1em;
      border-style: solid;
      width: 2em;
      height: 2em;
      place-self: end;
      position: relative;
      top: -1.5em;
      left: 5em;
      color: dimgrey;
      scale:.8;
    }
    #range-help {
      width: 5em;
      scale: .4;
      align-self: start;
      accent-color: dimgrey;
      position: relative;
      bottom: .2em;
      margin-bottom: -1em;
    }
    #btn-help {
      scale: .66;
      align-self: start;
      position: relative;
      bottom: .3em;
      color: dimgray;
      width: 2.33em;
    }
    #switch-help {
      scale: .4;
      align-self: initial;
      position: relative;
      top: 0em;
      left: 0em;
    }
    #button {
      width: 2.66em;
      height: 2.66em;
      place-self: center;
      position: relative;
      top: -.66em;
    }
    #total {
      display: flex;
      justify-content: flex-end;
      margin-top: -3em;
    }
    #focus {
      font-size: 2em;
      border: .1em solid white;
      padding: .33em;
    }
    #title {
      grid-column: 1/span 2;
      margin-bottom: .33em;
    }
    /* The switch - the box around the slider */
    .switch {
      position: absolute;
      display: inline-block;
      width: 60px;
      height: 34px;
      grid-column: 1;
      scale: .6;
      left: -.5em;
      bottom: .2em;
    }

    /* Hide default HTML checkbox */
    .switch input {
      opacity: 0;
      width: 0;
      height: 0;
    }

    /* The slider */
    .slider {
      position: absolute;
      cursor: pointer;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background-color: #b7b7b7;
      -webkit-transition: .4s;
      transition: .4s;
      border-radius: 1em;
    }

    .slider:hover {
      background-color: #999;
    }

    .slider:before {
      position: absolute;
      display: inline-block;
      text-align: center;
      line-height: 1;
      content: "g";
      font-size: 1.33em;
      color: darkgrey;
      height: 26px;
      width: 26px;
      left: 4px;
      bottom: 4px;
      background-color: white;
      -webkit-transition: .4s;
      transition: .4s;
      border-radius: 50%;
    }

    input:checked + .slider {
      background-color: #EEDFC9;
    }

    input:checked + .slider:hover {
      background-color: #E8CEA9;
    }

    input:checked + .slider:before {
      -webkit-transform: translateX(26px);
      -ms-transform: translateX(26px);
      transform: translateX(26px);
      color: dimgrey;
    }
    '''
  --
--
