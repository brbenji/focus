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
  ?:  |((~(has by args) 'begin') (~(has by args) 'nav'))
    ?:  (~(has by args) 'reveal')
      ::  reveals the hidden rest inputs
      ::    perhaps the name should have been multi or more?
      ::
      [%reveal &]
    ?:  =((~(got by args) 'nav') '?')
      ::  allows my submit button value to be ? and not help
      ::
      [%maneuver groove (display.focus %help) | delivery]
    ?:  =((~(got by args) 'nav') 'X')
      ::  exit help
      ::
      [%maneuver groove (display.focus %form) | delivery]
    ?.  (~(has by args) 'h')
      ::  the time setting code below won't work unless nav produces h m s etc
      ::    this produces the existing groove instead
      ::
      [%maneuver groove (displayify (slav %tas (~(got by args) 'nav'))) | delivery]
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
    =/  reps  `@ud`(slav %ud ?~(num=(~(got by args) 'reps') ?.(reveal '1' '2') num))
    =/  rest  `@dr`(slav %dr (crip r-time))
    ::  wrep is just a copy of wrap for now
    ::  =/  wrep  `@ud`(slav %ud (~(got by args) 'wrep'))
    ::
    =/  wrep  wrap
    ~&  "delivery in pages {<delivery>}"
    [%maneuver (gruv [focus wrap reps rest wrep]) (displayify %clock) & delivery]
  ::  XX: add this functionality
  ::
  ?:  (~(has by args) 'cont')
    ~&  "we hit cont people"
    [%cont &]
  ?:  (~(has by args) 'pause')
    ~&  "we hit pause people"
    [%pause &]
  ~
::
++  build
  |=  $:  arg=(list [k=@t v=@t])
          msg=(unit [o=? =@t])
      ==
  ^-  reply:rudder
  ::  XX: change this to an %xtra reply
  ::      add the header "keep-alive: timeout=<refresh>, max=<(add
  ::      refresh 5s)>"
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
          ?:  &(=(mode %focus) (gte reps 2))
            ;source(src "focus/assets/rest/wav", type "audio/wav");
          ?:  =(mode %rest)
            ;source(src "focus/assets/focus/wav", type "audio/wav");
          ;source(src "focus/assets/begin/wav", type "audio/wav");
        ==
        ;div.clock
          ;div.face.brothers
            ;form.brothers(method "post")
              ;input.to-form(type "submit", name "nav", value "form");
            ==
            ;svg.brothers(viewbox "0 0 100 100")
              ;circle#wipe(cx "50", cy "50", r "3em");
            ==
            ;svg#wrap-icon.brothers(viewbox "0 0 100 100")
              ;polygon(style "fill:white", points "{(~(got by wrap-icon) wrap.groove)}");
            ==
            ;+
            ?:  =(mode %fin)
              ;strong.time.brothers: {<display>}
            ?:  =(mode %rest)
              ;div.time-rest.brothers
                ;strong.time(style "font-size: 2.33em"): {(face rest.groove)}
                ;strong#rest: rest
                ;p#rep-count(style "top: 3em; left: 2.8em"): {<reps>} of {<reps.groove>}
              ==
            ?.  reveal  ;strong.time.brothers: {(face focus.groove)}
            ;div.brothers
              ;strong.time: {(face focus.groove)}
              ;p#rep-count: {<reps>} of {<reps.groove>}
            ==
          ==
        ==
        ;div.footer
          ;p#total: {total}
          ;form.pause.hide(method "post", autocomplete "off")
            ;input#help.transparent(type "submit", name "nav", value "?");
            ;+
            ?:  =(prev-cmd %pause)
              ;input#button(type "submit", name "cont", value "|>");
            ?:  =(prev-cmd %cont)
              ;input#button(type "submit", name "pause", value "||");
            ;input#button(type "submit", name "pause", value "||");
          ==
          ;+  ?:  =(mode %rest)
            ;audio#wrep-wav.hide(controls "")
              ;source(src "focus/assets/wrep/wav", type "audio/wav");
            ==
          ;audio#wrap-wav.hide(controls "")
            ;source(src "focus/assets/wrap/wav", type "audio/wav");
          ==
        ==
      ==
    ?:  =(display %form)
      ;div#wrapper
        ;audio.hide(controls "", autoplay "")
          ;+  ?:  reveal  ;source(src "focus/assets/reps/wav", type "audio/wav");
            ;source(src "focus/assets/form/wav", type "audio/wav");
        ==
        ;div#form-display.clock
          ;form.set.reveal(method "post", autocomplete "off")
            ;strong.label(style "{?:(reveal "" "margin-top: 2em")}"): focus
            ;input(type "number", name "h", placeholder "h", min "0");
            ;input(type "number", name "m", placeholder "m", min "0");
            ;input(type "number", name "s", placeholder "s", min "0");
            ;input.range(type "range", name "wrap", id "wrap", min "5", max "9", value "8", oninput "percent.value=wrap.valueAsNumber + '0%'");
            ;output(name "percent", for "wrap");
            ;+  ?.  reveal  ;div;
              ;strong.label: rest
            ;input(type "{reveal-rest}", name "rh", placeholder "h", min "0");
            ;input(type "{reveal-rest}", name "rm", placeholder "m", min "0");
            ;input(type "{reveal-rest}", name "rs", placeholder "s", min "0");
            ;input.range(type "hidden", name "wrep", min "5", max "9", value "8");
            ;input(type "hidden", name "nav", value "clock");
            ;input#reps(type "{reveal-rest}", name "reps", placeholder "x2", min "1");
            ;+  ?:  reveal  ;div;
              ;input#reps-btn(type "submit", name "reveal", value "x2");
            ;input#begin(type "submit", name "begin", value ">");
          ==
        ==
        ;div.footer
          ;form.pause(method "post")
            ;input#help(type "submit", name "nav", value "?");
          ==
        ==
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
        ==
        ;div.footer
          ;form.pause(method "post")
            ;input#help-x(type "submit", name "nav", value "X");
          ==
        ==
      ==
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
    ==
    ==  ==
  ::  "THIS CODE KILLS 99.99% OF JAVASCRIPT"
  ::  XX: use long-polling to do the same thing
  ::    these setTimeout funcions are doing but
  ::    with rudder instead.
  ::
  ++  script
    """
    setTimeout(() => \{
      document.location.reload();
      console.log('re-re-refresh!');
    }, {handle-refresh});

    setTimeout(() => \{
      document.getElementById({<?:(=(mode %rest) "wrep-wav" "wrap-wav")>}).play();
      console.log('wrap it up!');
    }, {handle-wrap});
    """
  ::  mod-style is built in a tape for code insertion
  ::
  ++  mod-style
    """
    #begin \{
      grid-column-end: 3;
      grid-row: {<?.(reveal 3 7)>};
      height: 2.33em;
      width: 3em;
      position: relative;
      top: {?:(reveal "1.45" "6.66")}em;
      left: .55em;
      border: 0.09em solid rgb(60,60,60);
      border-radius: 0.33em;
    }
    circle \{
      stroke: black;
      fill: none;
      stroke-width: 6em;
      stroke-dasharray: 314; /* equal to circumference of circle 2 * 3.14 * 50 */
      stroke-dashoffset: 201; /* initial setting */
      filter: blur(.04em);
      animation: wipe {?:(=(mode %rest) (duration rest.groove) (duration focus.groove))}ms infinite linear;
    }
    @keyframes wipe \{
      0% \{
        stroke-dashoffset: {?~(focus.groove "0" "314")};
      }
      100% \{
        stroke-dashoffset: 0;
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
  ::  helper arms for dynamically changing
  ::    +script, +mod-style, +build
  ::
  ++  delay
    ::  naive adjustment for delay in ms
    ::    we delay the vfx but not js refresh
    ::    refresh needs to occur asap
    ::
    120
  ++  reveal-rest
    ?:  reveal
      "number"
    "hidden"
  ++  duration
    |=  rel=@dr
    ^-  tape
    ::  yell produces [d= h= m= s=] from @dr
    ::
    =/  sec  (yell rel)
    =/  total  (add (mul hor:yo h.sec) (add (mul mit:yo m.sec) s.sec))
    =/  ms  (mul total 1.000)
    (a-co:co (add ms delay))
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
  ++  refresh
    ::  refresh is redundant with duration
    ::    but this can be deleted if we can go 0% js
    ::
    |=  rel=@dr
    ^-  tape
    =/  sec  (yell rel)
    =/  total  (add (mul hor:yo h.sec) (add (mul mit:yo m.sec) s.sec))
    =/  ms  (mul total 1.000)
    (a-co:co ms)
  ++  handle-refresh
    ?:  =(display %clock)
      ?:  =(mode %focus)
        :: (refresh focus.groove)
        ::
        (refresh ~s1)
      ?:  =(mode %rest)
        ::  (refresh rest.groove)
        ::
        (refresh ~s1)
      (a-co:co (mul day:yo 1.000))
    ::  sounds like poetry but it's just a day in seconds
    ::  in a tape "86460"
    ::
    (a-co:co (mul day:yo 1.000))
  ++  wrap-up
    |=  rel=@dr
    ^-  @dr
    ?:  =(mode %focus)
      `@dr`(mul wrap.groove (div rel 10))
    ?>  =(mode %rest)
      `@dr`(mul wrep.groove (div rel 10))
  ++  handle-wrap
    ?:  =(display %clock)
      ?:  =(mode %focus)
        (refresh (wrap-up focus.groove))
      ?:  =(mode %rest)
        (refresh (wrap-up rest.groove))
      (a-co:co (mul day:yo 1.000))
    (a-co:co (mul day:yo 1.000))
  ::
  ++  style
    '''
    * {
      margin: 0;
      box-sizing: border-box;
    }
    input[type=number]::-webkit-inner-spin-button {
      opacity: 1
    }
    svg {
      transform: rotate(-90deg);
      scale:2;
    }
    input {
      font-weight: 700;
      cursor: pointer;
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
    .help {
      grid-template-columns: 2.66em auto;
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
    .set {
      display: grid;
      grid-template-columns: 2.8em 3.1em 2.8em;
      grid-gap: .33em;
      accent-color: dimgray;
      margin-right: -.33em;
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
      display: grid;
      place-content: center;
      height: 0em;
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
    .brothers {
      grid-row: 1;
      grid-column: 1;
    }
    .footer {
      margin-top: 2em;
      width: 22em;
    }
    .clock {
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
      background-color: white;
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
      top: .66em;
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
    '''
  --
--
