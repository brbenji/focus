/-  *focus
/+  rudder, agentio, verb, dbug, default-agent
/~  pages  (page:rudder tack command)  /app/webui
::
|%
+$  versioned-state
  $%  state-0
  ==
::  groove ex: ~m20 9 2 ~m5 8
::    this says: focus for 20min, wrap-up call at 90% of way the through,
::    do 2 repitions, with a 5min rest with a call back 80% of way
::    through rest.
::
+$  state-0  [%0 groove=gruv =then =state-p]
+$  card  card:agent:gall
--
=|  state-0
=*  state  -
%-  agent:dbug
%+  verb  |
^-  agent:gall
|_  bowl=bowl:gall
+*  this  .
    def   ~(. (default-agent this %|) bowl)
    io    ~(. agentio bowl)
::
++  on-init
  ^-  (quip card _this)
  :_  this(state [%0 [~m5 9 1 ~s30 8] [now.bowl now.bowl] [%enter %focus %fresh |]])
  ~[(~(connect pass:io /connect) [[~ /[dap.bowl]] dap.bowl])]
::
++  on-save  !>(state)
::
++  on-load
  |=  saved=vase
  ^-  (quip card _this)
  ~&  ~(key by pages)
  =/  ole  !<(versioned-state saved)
  `this(state ole)
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?>  (team:title our.bowl src.bowl)
  ?+  mark  (on-poke:def mark vase)
      %focus-command
    =/  command  !<(command vase)
    ?-    -.command
        %pause
      ~&  'oops no pause'
      `this(prev-cmd.state-p %pause)
        %cont
      ~&  'oops all begins'
      `this(prev-cmd.state-p %cont)
        %maneuver
      ?.  begin.command
        ~&  'begin aint true'
        `this(display.state-p display.command)
      ~&  'easing in'
      ~&  "groove be {<gruv.command>}"
      =/  ease  (add now.bowl ~s4)
      :-  ~[(~(wait pass:io /rest) ease)]
      %=  this
        groove.state  gruv.command
        prev-cmd.state-p  %begin
        then  [ease ease]
        display.state-p  display.command
      ==
        %focus
      ~&  'focus mode'
      =/  focus  focus.groove
      =/  wrap  wrap.groove
      =/  setfocus  (add now.bowl focus)
      =/  setwrap  (add now.bowl (mul wrap (div focus 10)))
      :-
      :~  (~(wait pass:io /focus) setfocus)
          (~(wait pass:io /wrap) setwrap)
      ==
      %=  this
        reps.groove  (dec reps.groove)
        then  [setfocus setwrap]
        mode.state-p  %focus
      ==
        %rest
      ~&  'focus mode'
      `this
    ==
    ::
      %handle-http-request
    ~&  "knock knock, http-request!" :: vase be {<!<(order:rudder vase)>}"
    ::  XX: record these in state to be used by %request-local
    ::
    ~&  "request:http be {<=/(order !<(order:rudder vase) [method.request.order body.request.order])>}"
    ~&  "secure be {<=/(order !<(order:rudder vase) secure.order)>}"
    ~&  "address be {<=/(order !<(order:rudder vase) address.order)>}"
    =;  out=(quip card _+.state)
      [-.out this(+.state +.out)]
    %.  [bowl !<(order:rudder vase) +.state]
    %:  (steer:rudder _+.state command)
      pages
      ::  it's public now!
      ::    XX:figure out how to make it %enter at every load.
      ::
      (point:rudder /[dap.bowl] | ~(key by pages))
      (fours:rudder +.state)
      |=  cmd=command
      ^-  $@  brief:rudder
          [brief:rudder (list card) _+.state]
      =^  caz  this
        (on-poke %focus-command !>(cmd))
      ['Processed succesfully.' caz +.state]
    ==
  ==
::
++  on-arvo
  |=  [=wire sign=sign-arvo]
  ^-  (quip card _this)
  ?+  -.wire  (on-arvo:def wire sign)
      %focus
    ?>  ?=([%behn %wake *] sign)
    ?:  =(reps.groove 0)
      ~&  'doneskis!'
      ::  XX: what display, mode, prev-cmd should be set after
      ::  doneskis!?
      ::
      ::  `this(mode %fin)
      `this
    ::  rest mode
    ::
    ~&  "{<mode.state-p>} mode"
    =/  rest  rest.groove
    =/  wrep  wrep.groove
    =/  setrest  (add now.bowl rest)
    =/  setwrep  (add now.bowl (mul wrep (div rest 10)))
    :_  this(then [setrest setwrep], mode.state-p %rest)
    :~  (~(wait pass:io /rest) setrest)
        (~(wait pass:io /wrap) setwrep)
    ==
    ::
      %rest
    ?>  ?=([%behn %wake *] sign)
    ::  focus mode
    ::
    ~&  "{<mode.state-p>} mode"
    =/  dumby-post  ~
    =/  vase-copy  [id=~.~.eyre_local authenticated=%.y secure=%.n address=[%ipv4 .127.0.0.1] request=[method=%'POST' url='/focus?rmsg=Processed%20succesfully.' header-list=~[[key='host' value='localhost'] [key='user-agent' value='Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:108.0) Gecko/20100101 Firefox/108.0'] [key='accept' value='text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8'] [key='accept-language' value='en-US,en;q=0.5'] [key='accept-encoding' value='gzip, deflate, br'] [key='referer' value='http://localhost/focus?rmsg=Processed%20succesfully.'] [key='connection' value='keep-alive'] [key='cookie' value='urbauth-~zod=0v7.ptntr.plr05.mr750.hc4cd.vtjlf'] [key='upgrade-insecure-requests' value='1'] [key='sec-fetch-dest' value='document'] [key='sec-fetch-mode' value='navigate'] [key='sec-fetch-site' value='same-origin'] [key='sec-fetch-user' value='?1']] body=[~ [p=60 q=67.544.574.948.467]]]]
    =/  vasey  !>(vase-copy)
    =/  request
      :^  %'GET'
          url='/focus'
          header-list=~[[key='host' value='localhost'] [key='user-agent' value='Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:108.0) Gecko/20100101 Firefox/108.0'] [key='accept' value='text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8'] [key='accept-language' value='en-US,en;q=0.5'] [key='accept-encoding' value='gzip, deflate, br'] [key='referer' value='http://localhost/focus?rmsg=Processed%20succesfully.'] [key='connection' value='keep-alive'] [key='cookie' value='urbauth-~zod=0v7.ptntr.plr05.mr750.hc4cd.vtjlf'] [key='upgrade-insecure-requests' value='1'] [key='sec-fetch-dest' value='document'] [key='sec-fetch-mode' value='navigate'] [key='sec-fetch-site' value='same-origin'] [key='sec-fetch-user' value='?1']]
          body=~
    =;  out=(quip card _+.state)
      [-.out this(+.state +.out)]
    %.  [bowl !<(order:rudder vasey) +.state]
    %:  (steer:rudder _+.state command)
      pages
      (point:rudder /[dap.bowl] & ~(key by pages))
      (fours:rudder +.state)
      |=  cmd=command
      ~&  'here I am in the on-arvo +solve! dont step on me! Im back from pages!'
      ^-  $@  brief:rudder
          [brief:rudder (list card) _+.state]
      =^  caz  this
        (on-poke %focus-command !>(cmd))
      ['Processed from on-arvo succesfully.' caz +.state]
    ==
    ::
      %wrap
    ?>  ?=([%behn %wake *] sign)
    ~&  'wrap up'
    `this
    ::
      %connect
    ?>  ?=([%behn %wake *] sign)
    ~&  'did we stop our install eyre response problem?'
    `this
  ==
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?>  =(our.bowl src.bowl)
  ?+  path  (on-watch:def path)
    [%http-response *]  [~ this]
  ==
::
++  on-agent  on-agent:def
++  on-peek   on-peek:def
++  on-leave  on-leave:def
++  on-fail   on-fail:def
--
