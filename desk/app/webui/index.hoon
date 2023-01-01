/-  *focus
/+  rudder
^-  (page:rudder groove=gruv command)
|_  [=bowl:gall * groove=gruv]
::
++  final  (alert:rudder (cat 3 '/' dap.bowl) build)
::
++  argue
  |=  [headers=header-list:http body=(unit octs)]
  ^-  $@(brief:rudder command)
  =/  args=(map @t @t)  ?~(body ~ (frisk:rudder q.u.body))
  ?:  (~(has by args) 'begin')
    ::  this creates "~h0.m45.s0"
    ::  XX: gotta be a better way to create this tape.
    ::
    =/  timer  ^-  tape
    :~  '~'
        'h'
        ?~(h=(~(got by args) 'h') '0' h)
        '.'
        'm'
        ?~(m=(~(got by args) 'm') '45' m)
        '.'
        's'
        ?~(s=(~(got by args) 's') '0' s)
    ==
    =/  setfocus  `@dr`(slav %dr (crip timer))
    ::  XX: add inputs for wrap and the rest.
    ::
    [%begin setfocus 9 2 ~s2 5]
  ?.  (~(has by args) 'pause')  ~
  [%pause &]


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
        ;style:"{(trip style)}"
        ;script:"{(trip script)}"
      ==
      ;body
        ;div.wrapper
          ;div.clock
            ;div;
            ;strong: focus
            ;form(method "post")
              ;input(type "number", name "h", placeholder "h");
              ;input(type "number", name "m", placeholder "m");
              ;input(type "number", name "s", placeholder "s");
              ;input(type "submit", name "begin", value ">");
            ==
          ==
          ;div.pause
            ;button(type "submit", name "pause"):"||"
          ==
        ==
      ==
    ==
  ++  script
    '''
    console.log('nothing here')
    '''
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
      grid-template-columns: 2.8em 3.1em 2.8em 2.2em;
      grid-template-rows: auto 1.66em;
      grid-gap: .33em;
    }
    input {
      font-weight: 700;
    }
    .pause {
      width: 2.33em;
      height: 1.66em;
      background-color: peachpuff;
      border: 3px outset darkslategray;
      border-radius: .33em;
      font-weight: 1000;
      font-size: 1.66em;
      scale:2;
    }
    '''
  --
--
