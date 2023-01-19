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
      [%reveal &]
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
    =/  reps  `@ud`(slav %ud ?~(num=(~(got by args) 'reps') ?.(reveal '1' '2') num))
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
  |=  $:  arg=(list [k=@t v=@t])
          msg=(unit [o=? =@t])
      ==
  ^-  reply:rudder
::  ++  audio
    ::  XX: look at %flap example and see if the 'GET' in
    ::  +handle-http-request can be managed here instead?
    ::  here's what I learned reading %flap:
    ::    pokes with mark %handle-http-request can have their vase
    ::    cast to a [@ta =inbound-request:eyre] in the end it needs to
    ::    poop out (quip card _this).
    ::    in %flap, the url.request.inboud-request is sent to server for
    ::    parsing out the url. like /focus/webui/asset/focus/wav.
    ::    then there is a fence for authenticated requests only with
    ::      ?.  (authenticated.inbound-request) which "sends" the
    ::      login page. otherwise branches on method.inbound-request to
    ::      determine if it's a POST or GET.
    ::
    ::    "send" is applying response:schooner to the @ta along with
    ::    info for status-code, header and a custom resource data.
    ::    (which is what hoon-school modified for audio).
    ::    +response will eventually poop out a (quip card _this), but
    ::    not before it branches on the resource type and constructs
    ::    appropriate $simple-payload:http for each.
    ::
    ::    the simple-payloads are goobled up by
    ::    +give-simple-payload:server which eats [@ta
    ::    simple-payload:http] and poops a (list card:agent:gall), the
    ::    list is three %give %fact on /http-response wire cards built
    ::    with the @ta and header plus data info in the simple-payload.
    ::
    ::     ++  give-simple-payload
    ::       |=  [eyre-id=@ta =simple-payload:http]
    ::       ^-  (list card:agent:gall)
    ::       =/  header-cage
    ::         [%http-response-header !>(response-header.simple-payload)]
    ::       =/  data-cage
    ::         [%http-response-data !>(data.simple-payload)]
    ::       :~  [%give %fact ~[/http-response/[eyre-id]] header-cage]
    ::           [%give %fact ~[/http-response/[eyre-id]] data-cage]
    ::           [%give %kick ~[/http-response/[eyre-id]] ~]
    ::       ==
    ::
    ::    spout:rudder is the same dang thing!
    ::    ++  spout  ::  build full response cards
    ::      |=  [eyre-id=@ta simple-payload:http]
    ::      ^-  (list card)
    ::      =/  =path  /http-response/[eyre-id]
    ::      :~  [%give %fact ~[path] [%http-response-header !>(response-header)]]
    ::          [%give %fact ~[path] [%http-response-data !>(data)]]
    ::          [%give %kick ~[path] ~]
    ::      ==
    ::    +apply:rudder and +serve:rudder use spout
    ::
    ::    the only thing left to do when this comes out of server is to
    ::    add this to them for a proper (quip card this).
    ::
    ::    how do a shortcircuit this with rudder? just add those cards
    ::    feeling good about my simple-payload from +paint:rudder.
    ::    XX: figure out where to get +spout:rudder involved and learn
    ::    to branch on something like a site from server, but with
    ::    rudder. maybe +point:rudder.
    ::      pages =trail:rudder is definitely involved. it destructures
    ::      the url and has an option extension at the end for files
    ::
    ::    from the frontend perspective let's go over sequence:
    ::      1:
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
              ;div.brothers
                ;strong.time(style "font-size: 2.33em"): {(face rest.groove)}
                ;strong#rest: rest
                ;p#rep-count(style "top: 3em; left: 3.1em"): {<reps>} of {<reps.groove>}
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
        ;div.clock
          ;strong: an interval timer
          ;br;
          ;p: focus - set a time for flow
            ; with a wrap-up call based on percentage
          ;p: x2 - run multiple sessions of focus
          ;p: rest - relax a moment
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
  ++  reveal-rest
    ?:  reveal
      "number"
    "hidden"
  ::  "THIS CODE KILLS 99.99% OF JAVASCRIPT"
  ::  XX: add another Timeout that play() the wrap and wrep
  ::  wav in their proper place.
  ::    calc wrap and wrep times
  ::    potentially dynamically swap the target of the js
  ::    play({<heads-up>})
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
  ++  delay
    ::  naive adjustment for delay in ms
    ::    we delay the vfx but not js refresh
    ::    refresh needs to occur asap
    ::
    120
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
        (refresh focus.groove)
      ?:  =(mode %rest)
        (refresh rest.groove)
      (a-co:co (mul day:yo 1.000))
    ::  sounds like poetry but it's just a day in seconds in a tape
    ::  "86460"
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
    .set \{
      display: grid;
      grid-template-columns: 2.8em 3.1em 2.8em;
      grid-gap: .33em;
      accent-color: dimgray;
      margin-right: -.33em;
    }
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
      stroke-dashoffset: 201; /* initial setting */
      filter: blur(.04em);
      animation: wipe {?:(=(mode %rest) (duration rest.groove) (duration focus.groove))}ms infinite linear;
    }
    @keyframes wipe \{
      0% \{
        stroke-dashoffset: 314;
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
    .reveal \{
      animation: enter 1s;
    }
    .rest \{
      visibility: hidden;
    }
    .hide \{
      visibility: hidden;
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
    output {
      grid-row: 3;
      grid-column: 1;
      position: relative;
      scale: .8;
      place-self: center;
      top: 1.2em;
      left: .5em;
      color: dimgray;
      animation: enter 1s;
    }
    .brothers {
      grid-row: 1;
      grid-column: 1;
    }
    input[type=number]::-webkit-inner-spin-button {
      opacity: 1
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
      margin-top: .2em;
    }
    .range {
      grid-column: 1/span 3;
      grid-row: 3;
      scale: .75;
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
      place-content: center;
      height: 0em;
      scale: 2;
      margin-right: -.5em;
    }
    svg {
      transform: rotate(-90deg);
      scale:2;
    }
    #total {
      display: flex;
      justify-content: flex-end;
      margin-top: -3em;
      scale: 1;
    }
    .footer {
      margin-top: 2em;
      width: 22em;
    }
    .transparent {
      opacity: 0;
    }
    '''
  --
--
