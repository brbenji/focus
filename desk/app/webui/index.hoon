::  XX: add wrap and wrep sounds and their triggers
::      recreate the wipe animation with css @keyframes and animation
::        property
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
    =/  reps  `@ud`(slav %ud ?~(num=(~(got by args) 'reps') '1' num))
    =/  rest  `@dr`(slav %dr (crip r-time))
    ::  wrep is just a copy of wrap for now
    ::  =/  wrep  `@ud`(slav %ud (~(got by args) 'wrep'))
    ::
    =/  wrep  wrap
    [%maneuver (gruv [focus wrap reps rest wrep]) (displayify %clock) &]
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
  ~&  "refresh display {<display>} mode {<mode>}"
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
    ;+
    ?:  =(display %clock)
      ;div#wrapper
        ;audio.hide(controls "", autoplay "")
          ;+
          ?:  &(=(mode %focus) (gte reps 2))
            ;source(src "{base-url}+SE_SYS_WIFI_MATCH_COMPLETE_rest.wav", type "audio/mp3");
          ?:  =(mode %rest)
            ;source(src "{base-url}+SE_SYS_WIFI_FRIEND_START_focus.wav", type "audio/mp3");
          ;source(src "{base-url}+SE_RSLT_NEW_RECORD.wav", type "audio/mp3");
        ==
        ;div.clock
          ;div.face.brothers
            ;form.brothers(method "post")
              ;input.to-form(type "submit", name "nav", value "form");
            ==
            ;svg.brothers(viewbox "0 0 100 100")
              ;circle#wipe(cx "50", cy "50", r "3em");
            ==
            ;+
            ?:  =(display %fin)
              ;strong.time.brothers: {<display>}
            ?:  =(mode %rest)
              ;strong.time.brothers: {<rest.groove>}
            ;strong.time.brothers: {<focus.groove>}
          ==
        ==
        ;div.footer
          ;form.pause.hide(method "post", autocomplete "off")
            ;input#help.transparent(type "submit", name "nav", value "?");
            ;+
            ?:  =(prev-cmd %pause)
              ;input#button(type "submit", name "cont", value "|>");
            ?:  =(prev-cmd %cont)
              ;input#button(type "submit", name "pause", value "||");
            ;input#button(type "submit", name "pause", value "||");
          ==
          ;p#total: {total}
        ==
      ==
    ?:  =(display %form)
      ;div#wrapper
        ;audio.hide(controls "", autoplay "")
          ;source(src "{base-url}+SE_SYS_RACE_OK.wav", type "audio/mp3");
        ==
        ;div#form-display.clock
          ;form.set(method "post", autocomplete "off")
            ;strong.label: focus
            ;input(type "number", name "h", placeholder "h", min "0");
            ;input(type "number", name "m", placeholder "m", min "0");
            ;input(type "number", name "s", placeholder "s", min "0");
            ;input.range.transparent(type "range", name "wrap", min "5", max "9", value "9");
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
        ;div.footer
          ;form#form-hack.pause(method "post")
            ;input#help(type "submit", name "nav", value "?");
          ==
          ;p#total.hide: {<`@dr`(mul (add focus.groove rest.groove) ?~(reps=reps.groove 1 reps))>}
          ;audio.hide(controls "")
            ;source(src "", type "audio/mp3");
          ==
        ==
      ==
    ?:  =(display %help)
      ;div#wrapper
        ;audio.hide(controls "", autoplay "")
          ;source(src "{base-url}+SE_RC_PAUSE_TO_NEXT.wav", type "audio/mp3");
         ==
        ;div.clock
          ;strong: an interval timer
          ;br;
          ;p: focus - ease into a time for flow
          ;p: rest - relax a moment
          ;p: reps - run multiple sessions of focus
        ==
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
          ;p#total.hide: {<total>}
        ==
      ==
    ;div#wrapper
      ;audio.hide(controls "", autoplay "")
        ;source(src "{base-url}+SE_RC_LAP.wav", type "audio/mp3");
      ==
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
      ;div.footer;
    ==
    ==  ==
  ++  base-url
      "https://birds-nest.sfo3.digitaloceanspaces.com/focus-audio/"
  ::  this waits for the page to load before changing stroke-dashoffset
  ::    to "0", animating the wipe, timed to focus.groove
  ::
  ::  "THIS CODE KILLS 99.99% OF JAVASCRIPT"
  ::  I hope these post load animations can actually be handles by scss
  ::  or some other pure css solution.
  ::
  ++  script
    """
    window.addEventListener('DOMContentLoaded', (event) => \{
       document.getElementById({<effect>}).style.strokeDashoffset="0";
       document.getElementById({<effect>}).style.opacity="100%";
       console.log('DOM fully loaded and parsed');
    });
    setTimeout(() => \{
      document.location.reload();
      console.log('re-re-refresh!');
    }, {handle-refresh});
    """
  ++  effect
    ::  another hacky moment
    ::
    ?:  =(display %enter)
      "enter"
    "wipe"
  ++  seconds
    |=  rel=@dr
    ^-  tape
    ::  yell produces [d= h= m= s=] from @dr
    ::
    =/  sec  (yell rel)
    =/  total  (add (mul hor:yo h.sec) (add (mul mit:yo m.sec) s.sec))
    =/  delay-s  (div delay 1.000)
    (a-co:co (add total delay-s))
  ++  delay
    ::  naive adjustment for delay
    ::    in ms
    ::
    1.500
  ++  total
    ^-  tape
    =/  combo  (add focus.groove rest.groove)
    =/  sets  ?~(reps 1 reps)
    =/  total  `@dr`(mul combo sets)
    "{<total>}"
  ++  refresh
    ::  refresh is redundant with seconds
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
        (refresh focus.groove)
      ?:  =(mode %rest)
        (refresh rest.groove)
      (a-co:co (mul day:yo 1.000))
    ::  sounds like poetry but it's just a day in seconds in a tape
    ::  "86460"
    ::
    (a-co:co (mul day:yo 1.000))
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
      transition: all {?:(=(mode %rest) (seconds rest.groove) (seconds focus.groove))}s;
    }
    .hide \{
      visibility: hidden;
    }
    """
  ::  mod-style helper arms
  ::
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
      transition: ease-in-out 2.5s;
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
      top: -4em;
      scale: 1;
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
