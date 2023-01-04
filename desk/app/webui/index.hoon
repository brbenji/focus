::  XX:
::      calc focus time and rest time in s, insert into css
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
  =/  args=(map @t @t)  ?~(body ~ (frisk:rudder q.u.body))
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
    ~&  "we hit nav people, where going to {<display>}"
    =/  display  `@tas`(slav %tas (~(got by args) 'nav'))
    [%nav display]
  ~
::
++  build
  |=  $:  arg=(list [k=@t v=@t])
          msg=(unit [o=? =@t])
      ==
  ^-  reply:rudder
  ::
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
            ;form(method "post")
              ;input(type "submit", name "nav", value "clock");
              ;input(type "submit", name "nav", value "form");
              ;input(type "submit", name "nav", value "help");
            ==
            ;div;
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
                ;input.form-end(type "submit", name "begin", value ">");
              ==
            ?:  =(display %clock)
              ;div.circle
                ;div.center;
                ;div.hours;
              ==
            ?:  =(display %help)
              ;p: here be help
            ;p: nothing to see here
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
            ;svg(viewbox "0 0 100 100")
               ;circle(cx "50", cy "50", r "20");
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
  ++  mod-style
    """
    .circle:before \{
      content: "";
      position: absolute;
      top: 10px;
      left: 146px;
      width: 8px;
      height: 140px;
      border-radius: 5px;
      background: #444;
      transform-origin: bottom;
      animation: time {<(add 500 100)>}s infinite linear;
    }
    """
  ++  style
    '''
    * {
      margin: 0;
      box-sizing: border-box;
    }
    .green { color: #229922; }
    .bold { font-weight: bold; }
    .wrapper {
      display: grid;
      place-items: center;
      grid-template-rows: 6em 20em 7em auto;
      grid-gap: 1em;
      height: 100vh;
    }
    .clock {
      display: grid;
      place-items: center;
      grid-template-rows: 2em auto auto;
      background-color: lightslategrey;
      margin: 1em;
      padding: .66em;
      border: 3px outset darkslategrey;
      border-radius: .66em;
      height: 9em;
      scale: 2;
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
    .circle {
      width: 300px;
      height: 300px;
      border-radius: 300px;
      background: whitesmoke;
      border: 4px solid #666;
      position: relative;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
    }
    .circle:after {
      content: "";
      position: absolute;
      top: 5px;
      left: 149px;
      width: 2px;
      height: 145px;
      border-radius: 5px;
      background: red;
      transform-origin: bottom;
      animation: time 60s infinite linear;
    }

    .center {
      position: absolute;
      width: 20px;
      height: 20px;
      border-radius: 20px;
      top: 140px;
      left: 140px;
      background: #444;
      z-index: 2;
    }

    .hours {
      position: absolute;
      top: 70px;
      left: 145px;
      width: 10px;
      height: 80px;
      border-radius: 5px;
      background: #444;
      transform-origin: bottom;
      animation: time 216000s infinite linear;
    }

    @keyframes time {
      100% {
        transform: rotate(360deg);
      }
    }
    svg {
      height: 100px;
      width: 100px;
      transform: rotate(-90deg) scale(1, -1);
    }
    circle {
      stroke: black;
      fill: none;
      stroke-width: 40px;
      stroke-dasharray: 314; /* equal to circumference of circle 2 * 3.14 * 50 */
      stroke-dashoffset: 0; /* initial setting */
      transition: all 2s;
    }
    svg:hover circle{
      stroke-dashoffset: 314;
    }
    '''
  --
--
