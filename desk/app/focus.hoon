/-  *focus
/+  rudder, agentio, verb, dbug, default-agent
/~  pages  (page:rudder tack command)  /app/webui
::
|%
+$  versioned-state
  $%  state-0
  ==
::  groove ex: ~s2 9 2 ~s5 8
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
  ::  .^((list [binding:eyre duct action:eyre]) %e /=bindings=)
  ::  scry to trouble shoot no binding on install.
  ::
  ::  XX: change clock to %enter when I create that display
  ::
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
      ::  XX: branch on begin
      ::      right now it starts a timer no matter what.
      ::
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
    ::  record these in state to be used by %request-local
    ::
    ~&  "request:http be {<=/(order !<(order:rudder vase) [method.request.order body.request.order])>}"
    ~&  "secure be {<=/(order !<(order:rudder vase) secure.order)>}"
    ~&  "address be {<=/(order !<(order:rudder vase) address.order)>}"
    =;  out=(quip card _+.state)
      [-.out this(+.state +.out)]
    %.  [bowl !<(order:rudder vase) +.state]
    %:  (steer:rudder _+.state command)
      pages
      (point:rudder /[dap.bowl] & ~(key by pages))
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
::  what must I do to send data back to the frontend
::  'my pages' from on-arvo here?
::  ^ on-watch might be a clue.
::  maybe the wire on-arvo can be %http-response?
::  and with that...no. I think I'm mostly sending
::  stuff out.
::
::  look at the out part of the on-poke rudder stuff.
::
++  on-arvo
  |=  [=wire sign=sign-arvo]
  ^-  (quip card _this)
  ?+  -.wire  (on-arvo:def wire sign)
      %focus
    ?>  ?=([%behn %wake *] sign)
    ?:  =(reps.groove 0)
      ~&  'doneskis!'
      ::  attempting to refresh the 'begin' play button and default clock
      ::  but from here it requires some eyre request, only a maybe?
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
    ::  stern is the back of a ship
    ::    we're using a local http request to get "back door" access to
    ::    rudder to trigger page rebuilds on arvo responses.
    ::
      %stern
    ~&  "backdoor! there must be a backdoor!"
    ~&  "show me a sign {<sign>}"
    `this

      %rest
    ?>  ?=([%behn %wake *] sign)
    ::  focus mode
    ::
    ~&  "{<mode.state-p>} mode"
    ~&  "groove be {<groove>}"
    =/  focus  focus.groove
    =/  wrap  wrap.groove
    =/  setfocus  (add now.bowl focus)
    =/  setwrap  (add now.bowl (mul wrap (div focus 10)))
    ::
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
      ::  the +solve handler, which is this gate below, is called on a
      ::  post request that has a successful +argue command
      ::  might not be useful for on-arvo. I just want to pass wait
      ::  timers
      ::
      |=  cmd=command
      ~&  'here I am in the on-arvo +solve! dont step on me! Im back from pages!'
      ^-  $@  brief:rudder
          [brief:rudder (list card) _+.state]
      =^  caz  this
        (on-poke %focus-command !>(cmd))
      ['Processed succesfully.' caz +.state]
    ==
    ::  move this to a new command %focus and one for %rest
    ::  arvo will now receive the wake up calls from %b shoot down a
    ::  phoney http post request, with +argue values for %timers, which
    ::  will produce a proper command which will be sent to on-poke
    ::  around here.
    ::
    ::  I don't think I can change this state from the +solve handler,
    ::  only command.
    ::
    ::  :-
    ::  :~  (~(wait pass:io /focus) setfocus)
    ::      (~(wait pass:io /wrap) setwrap)
    ::      ::  [%request-local secure=? =address =request:http]
    ::      ::
    ::      [%pass /stern %arvo %e %request-local | [%ipv4 .127.0.0.1] request]
    ::      :: (~(poke-self pass:io /stern) cagey)
    ::  ==
    ::  %=  this
    ::    reps.groove  (dec reps.groove)
    ::    then  [setfocus setwrap]
    ::    mode.state-p  %focus
    ::  ==
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

   ::   %bind-focus
   :: ~?  !accepted.sign
   ::   [dap.bowl 'eyre bind rejected!' binding.sign-arvo]
   :: [~ this]
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
