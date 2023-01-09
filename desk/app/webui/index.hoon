::  XX:
::      create an svg that indicates wrap and is set in place based on
::      bubble up the value of wrap range
::      %form should pop up without rest inputs, but reps should be a
::        button to turn rest on.
::      collect the right sounds and play them at the right moment
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
  ~&  "order:rudder be {<[id.order method.request.order body.request.order]>}"
  |=  [headers=header-list:http body=(unit octs)]
  ^-  $@(brief:rudder command)
  =/  args=(map @t @t)  ?~(body ~ (frisk:rudder q.u.body))
  ?:  |((~(has by args) 'begin') (~(has by args) 'nav'))
    ?:  =((~(got by args) 'nav') '?')
      ::  allows my submit button value to be ? and not help
      ::
      [%maneuver groove (display.focus %help) |]
    ?:  =((~(got by args) 'nav') 'X')
      ::  exit help
      ::
      [%maneuver groove (display.focus %form) |]
    ?.  (~(has by args) 'h')
      ::  the time setting code below won't work unless nav produces h m s etc
      ::    this produces the existing groove instead
      ::
      [%maneuver groove (displayify (slav %tas (~(got by args) 'nav'))) |]
    ::  this creates "~h0.m0.s0"
    ::    converting null to '0'
    ::
    =/  f-time  ^-  tape
    :~  '~h'
        ::
        ?~(h=(~(got by args) 'h') '0' h)
        ::
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
    ::
    =/  focus  `@dr`(slav %dr (crip f-time))
    =/  wrap  `@ud`(slav %ud (~(got by args) 'wrap'))
    =/  reps  `@ud`(slav %ud ?~(num=(~(got by args) 'reps') '1' num))
    =/  rest  `@dr`(slav %dr (crip r-time))
    ::  wrep is just a copy of wrap for now
    ::  =/  wrep  `@ud`(slav %ud (~(got by args) 'wrep'))
    ::
    =/  wrep  wrap
    [%maneuver (gruv [focus wrap reps rest wrep]) (displayify %clock) &]
  ?:  (~(has by args) 'cont')
    ~&  "we hit cont people"
    [%cont &]
  ?:  (~(has by args) 'pause')
    ~&  "we hit pause people"
    [%pause &]
  ?:  (~(has by args) 'stern')
    ~&  "we wen't through the backdoor"
    [%focus groove]
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
        ;meta(charset "utf-8");
        ;meta(name "viewport", content "width=device-width, initial-scale=1");
        ;style:"{(weld (trip style) mod-style)}"
        ;script:"{script}"
      ==
      ;body
        ;div#wrapper
          ;form(method "post")
            ;input(type "submit", name "nav", value "enter");
          ==
          ;+
          ?:  =(display %enter)
            ;div#enter.clock
              ;form.brothers(method "post")
                ;input.to-form(type "submit", name "nav", value "form", autofocus "");
              ==
              ;div.face.brothers
                ;svg.brothers(viewbox "0 0 100 100")
                  ;circle(cx "50", cy "50", r "3em");
                ==
                ;strong#focus.time.brothers: focus
              ==
            ==
          ?:  =(display %clock)
            ;div.clock
              ;div.face.brothers
                ;form.brothers(method "post")
                  ;input.to-form(type "submit", name "nav", value "form");
                ==
                ;svg.brothers(viewbox "0 0 100 100")
                  ;circle#wipe(cx "50", cy "50", r "3em");
                ==
                ;strong.time.brothers: {<focus.groove>}
              ==
            ==
          ?:  =(display %form)
            ;div#form-display.clock
              ;form.set(method "post")
                ;strong.label: focus
                ;input(type "number", name "h", placeholder "h", min "0");
                ;input(type "number", name "m", placeholder "m", min "0");
                ;input(type "number", name "s", placeholder "s", min "0");
                ;input.range(type "range", name "wrap", min "5", max "9", value "9");
                ;strong.label: rest
                ;input(type "number", name "rh", placeholder "h", min "0");
                ;input(type "number", name "rm", placeholder "m", min "0");
                ;input(type "number", name "rs", placeholder "s", min "0");
                ;input.range(type "hidden", name "wrep", min "5", max "9", value "9");
                ;input(type "hidden", name "nav", value "clock");
                ;input#reps(type "number", name "reps", placeholder "x1", min "1");
                ;input#begin(type "submit", name "begin", value ">");
              ==
            ==
          ?:  =(display %help)
              ;div.clock
                ;strong: an interval timer
                ;br;
                ;p: focus - ease into a time for flow
                ;p: wrap - wrap-up signal based on percentage of time set
                ;p: reps - run multiple sessions of focus
                ;p: rest - relax a moment
              ==
          ;p: oh-no! this is empty!;
          ;+
          ?:  =(display %enter)
            ;div.footer
            ;button(name "nav", value "?");
            ==
          ?:  =(display %form)
            ;div.footer
              ;form#form-hack.pause(method "post")
                ;input#help(type "submit", name "nav", value "?");
              ==
              ;p#total.hide: {<`@dr`(mul (add focus.groove rest.groove) ?~(reps=reps.groove 1 reps))>}
              ;audio.hide(controls "", autoplay "")
                ;source(src "https://birds-nest.sfo3.digitaloceanspaces.com/focus-audio/+SE_SYS_RACE_OK.wav", type "audio/mp3");
              ==
            ==
          ?:  =(display %help)
            ;div.footer
              ;form.pause(method "post")
              ;input#help(type "submit", name "nav", value "X");
              ;+
              ?:  =(prev-cmd %pause)
                ;input#button.transparent(type "submit", name "cont", value "|>");
              ?:  =(prev-cmd %cont)
                ;input#button.transparent(type "submit", name "pause", value "||");
              ;input#button.transparent(type "submit", name "pause", value "||");
            ==
            ;p#total.hide: {<`@dr`(mul (add focus.groove rest.groove) ?~(reps=reps.groove 1 reps))>}
          ==
          ;div.footer.hide
            ;form.pause(method "post")
              ;input#help.transparent(type "submit", name "nav", value "?");
              ;+
              ?:  =(prev-cmd %pause)
                ;input#button(type "submit", name "cont", value "|>");
              ?:  =(prev-cmd %cont)
                ;input#button(type "submit", name "pause", value "||");
              ;input#button(type "submit", name "pause", value "||");
            ==
            ;p#total: {<`@dr`(mul (add focus.groove rest.groove) ?~(reps=reps.groove 1 reps))>}
          ;audio(controls "", autoplay "")
            ;source(src "https://birds-nest.sfo3.digitaloceanspaces.com/focus-audio/+SE_SYS_RACE_OK.wav", type "audio/mp3");
          ==
          ==
        ==
      ==
    ==
  ::  rest or doneskis sound
  ::    https://birds-nest.sfo3.digitaloceanspaces.com/focus-audio/+SE_RC_LAP2.wav
  ::  this waits for the page to load before changing stroke-dashoffset
  ::    to "0", animating the wipe, timed to focus.groove
  ::
  ++  script
    """
    window.addEventListener('DOMContentLoaded', (event) => \{
       document.getElementById({<effect>}).style.strokeDashoffset="0";
       document.getElementById({<effect>}).style.opacity="100%";
       console.log('DOM fully loaded and parsed');
    });
    """
  ++  effect
    ::  another hacky moment
    ?:  =(display %enter)
      "enter"
    "wipe"
  ::  mod-style is built in a tape for code insertion
  ::
  ++  mod-style
    """
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
      background-color: white;
    }
    .time \{
      font-size: 3em;
      color: white;
      mix-blend-mode: difference;
    }
    #focus \{
      font-size: 2em;
      border: .1em solid white;
      padding: .33em;
    }
    circle \{
      stroke: black;
      fill: none;
      stroke-width: 6em;
      stroke-dasharray: 314; /* equal to circumference of circle 2 * 3.14 * 50 */
      stroke-dashoffset: {<dashoffset>}; /* initial setting */
      filter: blur(.04em);
      transition: all {<seconds>}s;
    }
    .hide \{
      visibility: hidden;
    }
    """
  ++  seconds
    ?:  =(prev-cmd %fresh)
      0
    ?:  =(mode %focus)
      =/  sec  (yell focus.groove)
      (add (mul hor:yo h.sec) (add (mul mit:yo m.sec) s.sec))
    ?:  =(mode %rest)
      =/  sec  (yell rest.groove)
      (add (mul hor:yo h.sec) (add (mul mit:yo m.sec) s.sec))
    0
  ++  dashoffset
    ?:  =(display %enter)
      201
    314
  ++  style
    '''
    * {
      margin: 0;
      box-sizing: border-box;
    }
    #wrapper {
      display: grid;
      place-items: center;
      grid-template-rows: 6em 20em 7em auto;
      grid-gap: 1em;
      height: 100vh;
    }
    #enter {
      opacity: 0%;
      transition: ease-in-out 3s;
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
    input[type=number]::-webkit-inner-spin-button {
      opacity: 1
    }
    #form-display {
      overflow: visible;
    }
    #form-hack {
      display: grid;
      scale: 2;
      position: relative;
      left: 3.9em;
      bottom: 2.2em;
      height: 0;
    }
    .set {
      display: grid;
      grid-template-columns: 2.8em 3.1em 2.8em;
      grid-template-rows: auto auto auto auto auto 1.66em;
      grid-gap: .33em;
      accent-color: dimgray;
      margin-right: -.33em;
    }
    #reps {
      grid-column: 3;
    }
    #help {
      border-radius: 1em;
      border-style: solid;
      width: 2em;
      height: 2em;
      place-self: end;
      position: relative;
      top: .66em;
      color: dimgrey;
      scale:.8;
    }
    #begin {
      grid-column-end: 3;
      grid-row: 7;
      height: 2.33em;
      width: 3em;
      position: relative;
      top: 1.66em;
      left: .55em;
      border: 0.09em solid rgb(60,60,60);
      border-radius: 0.33em;
    }
    #button {
      width: 2.66em;
      height: 2.66em;
      place-self: center;
      position: relative;
      top: -.66em;
    }
    .label {
      grid-column: 1/span 4;
      place-self: center;
    }
    .range {
      grid-column: 1/span 3;
    }
    input {
      font-weight: 700;
      cursor: pointer;
    }
    p {
      scale: .66;
      place-self: start;
    }
    .pause {
      display: grid;
      scale: 2;
      width: 11em;
    }
    svg {
      transform: rotate(-90deg);
      scale:2;
    }
    #total {
      position: relative;
      left: 13em;
      top: 4em;
    }
    .footer {
      margin-top: 1em;
    }
    .transparent {
      opacity: 0;
    }
    '''
  --
--
::
::  XX: huge problem with names (display mold esp.) in these pages
::        something about nesting state-p into tack that screwed things
::        up. one fix for the /app was to remove state-0 from /sur
::        although maybe that was superstition. probably not.
::      some improvements but super messy with display.focus and
::        displayify. I really don't get it.
::        run this here in pages and in the app to figure out what's going
::        on.
::          ~&  "state-p be {<state-p>}"
::          ~&  "display be {<display>}"
::          ~&  "displayify be {<displayify>}"
::          ~&  "state be {<state>}"
::          ~&  "state in pages be {<[then groove prev-cmd display mode begin]>}"
::
::    x calc focus time and rest time in s, insert into css
::        inject css based on mode. requires understanding refresh
::
::      build the rest functionality
::      every entry of reps input:number needs to make a post request
::        so that when it is (gte 2) it reveals/inserts the rest form
::
::      remove %mod command
::        the scenario for it doesn't seem too likely.
::        I love the thought of moving the wrap indicator around the
::        clock to set it, but it's too much for now.
::
::        instead we will simply have nav to %form by clicking on the
::        clock, which will %pause, and setting a new groove will start
::        it all again.
::
::      nav options
::        #enter -> %form
::        'help' -> %help
::          'X'  -> %form
::        'begin' -> %clock
::        'pause' -> %clock with 'cont' button
::        .clock -> %form
::
::        help will only exist in %form
::
::    notes of hack
::      #form-hack - in %form display we hide the help button's grid
::      neighbor, the pause/cont button within footer and that moves the
::      help button too far in.
::        changing z-index only made the help button non-functional.
::        this was a possible solution when considering just making the
::        pause/cont button invisible instead of non-existent.
::
::      +effect - because js and it's dynamic type scripting is garbage.
::      this swaps the #ids based on display so that the top onload call
::      can happen without the other id existing. js totally bails on
::      %form display.
::        a less hacky was would be to insert different full lines of js
::        based on display, but inserting tapes/cords into tape and
::        cords blocks is either not possible or very difficult to
::        figure out.
