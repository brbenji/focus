::  XX: page refresh does not work as I suspect, doesn't a GET request
::        produce a new page? maybe it requires a post?
::    x calc focus time and rest time in s, insert into css
::        inject css based on mode. requires understanding refresh
::      calc total time for a ;p at bottom of page
::
::      link the 'begin' button to submit the groove form
::        even for wrap range on the clock face
::      learn how to make an http-request from on-arvo doneskis.
::      improve the form visual
::        grid area template
::        learn possible css manipulation of forms
::        try to curve the range input around the clock square
::
::      display a text of the total groove time
::      craft the clock face (ticking down in numbers is a maybe)
::      craft a visual representation of time passing (wipe effect)
::      add sound (use howler.js?
::        this might require using de:json and json marks)
::
::      build the rest functionality
::      every entry of reps input:number needs to make a post request
::        so that when it is (gte 2) it reveals/inserts the rest form
::
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
  ~&  "prev-cmd be {<prev-cmd>} at the top of argue"
  ~&  "prev-cmd be {<display>}"
  =/  args=(map @t @t)  ?~(body ~ (frisk:rudder q.u.body))
  ::  ?:  =(mode %fin)
  ::    [%nav %clock]
  ?:  (~(has by args) 'begin')
    ::  this creates "~h0.m0.s0"
    ::    converting null to '0'
    ::  XX: gotta be a better way to create this tape.
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
    =/  focus  `@dr`(slav %dr (crip f-time))
    =/  wrap  `@ud`(slav %ud (~(got by args) 'wrap'))
    =/  reps  `@ud`(slav %ud ?~(num=(~(got by args) 'reps') '1' num))
    =/  rest  `@dr`(slav %dr (crip r-time))
    =/  wrep  `@ud`(slav %ud (~(got by args) 'wrep'))
    [%begin focus wrap reps rest wrep]
  ?:  (~(has by args) 'pause')
    ~&  "we hit pause people"
    [%pause &]
  ?:  (~(has by args) 'nav')
    =/  display  `@tas`(slav %tas (~(got by args) 'nav'))
    [%nav display]
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
        ;div.wrapper
          ;div;
          ;div.clock
            ;svg(viewbox "0 0 100 100")
               ;circle(cx "50", cy "50", r "22");
             ==
            ;strong.time: {<focus.groove>}
            ;+
            ?:  =(display %form)
              ;form(method "post")
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
                ;input.form-end(type "number", name "reps", placeholder "x1", min "1");
                ;input.form-end(type "submit", name "begin", name "nav", name "focus", value ">");
              ==
            ?:  =(display %help)
              ;p: here be help
            ;div;
          ==
          ;div.pause
            ;form(method "post")
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
            ==
          ==
        ==
      ==
    ==
  ++  script
    '''
    console.log('nothing here')
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
  ::  stroke-dashoffset: {<?:(=(mode %focus) 0 314)>}
  ::    this works! but I don't know how to start it at 314,
  ::    then change to 0 in that page, so the transition takes
  ::    the seconds of the focus?
  ::
  ::    could I engage a hover effect?
  ::    is there another wipe effect that would work in tandum with
  ::    the ::before ticking arm option?
  ::
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
      height: 9em;
      width: 9em;
      scale: 2;
      overflow: hidden;
      background-color: white;
    }
    .clock:before \{
      content: "";
      position: absolute;
      height: 9em;
      width: .2em;
      left: 50%;
      bottom: 50%;
      border-radius: .66em;
      background: #444;
      transform-origin: bottom;
      animation: time {<seconds>}s infinite linear;
    }
    .time \{
      font-size: 3em;
      color: white;
      mix-blend-mode: difference;
      grid-row: 1;
      grid-column: 1;
    }
    circle \{
      stroke: black;
      fill: none;
      stroke-width: 2.75em;
      stroke-dasharray: 314; /* equal to circumference of circle 2 * 3.14 * 50 */
      stroke-dashoffset: 314; /* initial setting */
      transition: all {<seconds>}s;
    }
    svg:hover circle \{
      stroke-dashoffset: 0;
    }
    """
  ++  style
    '''
    * {
      margin: 0;
      box-sizing: border-box;
      transition: ease-in-out 1s;
    }
    .wrapper {
      display: grid;
      place-items: center;
      grid-template-rows: 6em 20em 7em auto;
      grid-gap: 1em;
      height: 100vh;
    }
    form {
      display: grid;
      grid-template-columns: 2.8em 3.1em 2.8em;
      grid-gap: .33em;
      accent-color: dimgray;
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
      width: 3.1em;
      height: 2.8em;
      background-color: peachpuff;
      border: 3px outset darkslategray;
      border-radius: .33em;
      scale:2;
    }
    @keyframes time {
      100% {
        transform: rotate(360deg);
      }
    }
    svg {
      transform: rotate(-90deg);
      scale:2;
      grid-row: 1;
      grid-column: 1;
    }
    '''
  --
--
