::  XX: page refresh does not work as I suspect, doesn't a GET request
::        produce a new page? maybe it requires a post?
::    x calc focus time and rest time in s, insert into css
::        inject css based on mode. requires understanding refresh
::
::      link the 'begin' button to submit the groove form
::        even for wrap range on the clock face
::      learn how to make an http-request from on-arvo doneskis.
::
::      craft the clock face (ticking down in numbers is a maybe)
::
::      build the rest functionality
::      every entry of reps input:number needs to make a post request
::        so that when it is (gte 2) it reveals/inserts the rest form
::
::      create the #enter display
::        it will have the cool fade in, strokeDashoffset: 200, and wrap
::        at 9, no dyno-butt or total
::        it can also slowly get to the strokeDeshoffset, for a really
::        cool opening, start at :300. (start 25% goto 33% on the wipe
::        effect)
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
::      create a %move cmd that sets groove, changes display, and gives
::        a loobean for a new %begin ? type.
::
::      nav options
::        first =display will now be apart of %begin cmd
::          +argue will branch on or |('begin' 'nav') and the state
::          groove will go into =gruv
::
::        #enter -> %form
::        'help' -> %help
::        'begin' -> %clock
::        'pause' -> %clock with 'cont' button
::        .clock -> %form
::
::        help will only exit in %form
::
/-  *focus
/+  rudder
^-  (page:rudder tack command)
|_  [=bowl:gall * tack]
::
++  final  (alert:rudder (cat 3 '/' dap.bowl) build)
::
++  argue
  |=  [headers=header-list:http body=(unit octs)]
  ^-  $@(brief:rudder command)
  =/  args=(map @t @t)  ?~(body ~ (frisk:rudder q.u.body))
  ::  ?:  =(mode %fin)
  ::    [%nav %clock]
  ~&  "or for begin-nav be like {<|((~(has by args) 'begin') (~(has by args) 'nav'))>}"
  ?:  |((~(has by args) 'begin') (~(has by args) 'nav'))
    ::  this creates "~h0.m0.s0"
    ::    converting null to '0'
    ::
    =+  display
    ?:  =((~(got by args) 'nav') '?')
      ::  allows my submit button value to be ? and not help
      ::
      =.  display  %help  ~
    =.  display  (^display (slav %tas (~(got by args) 'nav')))
    ::  these won't work unless nav produces h m s etc key and value
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
    =/  focus  `@dr`(slav %dr (crip f-time))
    =/  wrap  `@ud`(slav %ud (~(got by args) 'wrap'))
    =/  reps  `@ud`(slav %ud ?~(num=(~(got by args) 'reps') '1' num))
    =/  rest  `@dr`(slav %dr (crip r-time))
    =/  wrep  `@ud`(slav %ud (~(got by args) 'wrep'))
    ::
    ~&  "nav be {<(~(got by args) 'nav')>}"
    ~&  "phew! we're in the begin-nav code."
    [%maneuver [focus wrap reps rest wrep] display &]
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
  ::  old buttons
  ::
  ::          ;form(method "post")
  ::            ;input(type "submit", name "nav", value "clock");
  ::            ;input(type "submit", name "nav", value "form");
  ::            ;input(type "submit", name "nav", value "help");
  ::          ==
  |^  [%page page]
  ++  page
    ^-  manx
    ;hmtl
      ;head
        ;title:"%focus"
        ;meta(charset "utf-8");
        ;meta(name "viewport", content "width=device-width, initial-scale=1");
        ;style:"{(weld (trip style) mod-style)}"
        ;script:"{(trip script)}"
      ==
      ;body
        ;div#wrapper
          ;form(method "post")
            ;input(type "submit", name "nav", value "clock");
            ;input(type "submit", name "nav", value "form");
          ==
          ;div.clock
            ;+
            ?:  =(display %clock)
              ;div.face
                ;svg(viewbox "0 0 100 100")
                  ;circle#wipe(cx "50", cy "50", r "3em");
                ==
                ;strong.time: {<focus.groove>}
              ==
            ?:  =(display %form)
              ;form.set(method "post")
                ;strong.label: focus
                ;input(type "number", name "h", placeholder "h", min "0");
                ;input(type "number", name "m", placeholder "m", min "0");
                ;input(type "number", name "s", placeholder "s", min "0");
                ;input.range(type "range", name "wrap", min "5", max "9", value ">");
                ;strong.label: rest
                ;input(type "number", name "rh", placeholder "h", min "0");
                ;input(type "number", name "rm", placeholder "m", min "0");
                ;input(type "number", name "rs", placeholder "s", min "0");
                ;input.range(type "range", name "wrep", min "5", max "9", value ">");
                ;input(type "hidden", name "nav", value "clock");
                ;input#reps(type "number", name "reps", placeholder "x1", min "1");
                ;input.form-end(type "submit", name "begin", value ">");
              ==
            ?:  =(display %help)
              ;p: here be help
            ;audio(controls "", autoplay "")
              ;source(src "https://raw.github.com/CodeExplainedRepo/Original-Flappy-bird-JavaScript/master/audio/sfx_point.wav", type "audio/mp3");
            ==
          ==
          ;form.pause(method "post")
            ;+
            ?:  =(prev-cmd %fresh)
              ;input(type "submit", name "begin", value ">");
            ?:  =(prev-cmd %begin)
              ;input(type "submit", name "pause", value "||");
            ?:  =(prev-cmd %pause)
              ;input(type "submit", name "cont", value "|>");
            ?:  =(prev-cmd %cont)
              ;input(type "submit", name "pause", value "||");
             ;input(type "submit", name "begin", value ">");
            ;input(type "submit", name "nav", value "?");
          ==
          ;p#total: {<`@dr`(mul (add focus.groove rest.groove) ?~(reps=reps.groove 1 reps))>}
        ==
      ==
    ==
  ::  this waits for the page to load before changing stroke-dashoffset
  ::    to "0", animating the wipe, timed to focus.groove
  ::
  ::  failed idea for slow loading the nice ease-in-out 1s on everything
  ::     document.getElementsByTagName("div").style.transition="ease-in-out 1s";
  ::
  ++  script
    '''
    window.addEventListener('DOMContentLoaded', (event) => {
       document.getElementById("wipe").style.strokeDashoffset="0";
       document.getElementById("enter").style.opacity="100%";
       console.log('DOM fully loaded and parsed');
    });
    '''
  ::  mod-style is built in a tape for code insertion
  ::
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
  ::  potential branch for clock vs form vs help for grid-template-rows
  ::    (?:(=(display %clock) "auto" "10% auto auto"));
  ::
  ++  mod-style
    """
    .clock \{
      display: grid;
      place-items: center;
      grid-template-rows: auto;
      margin: 1em;
      padding: .66em;
      border: .1em solid black;
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
      grid-row: 1;
      grid-column: 1;
      text-shadow: 1px 2px 2px rgba(255, 255, 255, 0.3);
    }
    circle \{
      stroke: black;
      fill: none;
      stroke-width: 6em;
      stroke-dasharray: 314; /* equal to circumference of circle 2 * 3.14 * 50 */
      stroke-dashoffset: 314; /* initial setting */
      filter: blur(.04em);
      transition: all {<seconds>}s;
    }
    """
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
      transition: ease-in-out 1s;
    }
    .face {
      display: grid;
      place-items: center;
    }
    .set {
      display: grid;
      grid-template-columns: 2.8em 3.1em 2.8em;
      grid-gap: .33em;
      accent-color: dimgray;
      margin-right: -.33em;
    }
    #reps {
      grid-column: 2;
    }
    .form-end {
      grid-column-end: 4;
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
    }
    .pause {
      display: grid;
      grid-template-columns: auto;
      scale:2;
    }
    svg {
      transform: rotate(-90deg);
      scale:2;
      grid-row: 1;
      grid-column: 1;
    }
    #total {
      position: relative;
      left: 9em;
    }
    '''
  --
--
