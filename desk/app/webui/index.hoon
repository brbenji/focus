::
/-  *focus
/+  rudder
^-  (page:rudder [=then =gruv =prev-cmd] command)
|_  [=bowl:gall * [=then =gruv =prev-cmd]]
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
        ;style:"{(trip style)}"
        ;script:"{(trip script)}"
      ==
      ;body
        ;div.wrapper
          ;div;
          ;div.clock
            ;form(method "post")
              ;strong: focus
              ;input(type "number", name "h", placeholder "h", min "0");
              ;input(type "number", name "m", placeholder "m", min "0");
              ;input(type "number", name "s", placeholder "s", min "0");
              ;input(type "range", name "wrap", min "5", max "9", value ">");
              ;strong: rest
              ;input(type "number", name "rh", placeholder "h", min "0");
              ;input(type "number", name "rm", placeholder "m", min "0");
              ;input(type "number", name "rs", placeholder "s", min "0");
              ;input(type "range", name "wrep", min "5", max "9", value ">");
              ;input(type "number", name "reps", placeholder "_x", min "1");
              ;input(type "submit", name "begin", value ">");
            ==
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
      grid-gap: .33em;
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
    '''
  --
--
