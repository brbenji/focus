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
  ~[(~(connect pass:io /eyre/connect) [[~ /[dap.bowl]] dap.bowl])]
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
      ~&  "display might be {<display.command>}"
      =/  ease  (add now.bowl ~s4)
      :-  ~[(~(wait pass:io /rest) ease)]
      %=  this
        groove.state  gruv.command
        prev-cmd.state-p  %begin
        then  [ease ease]
        display.state-p  display.command
      ==
    ==
    ::
      %handle-http-request
    ~&  "knock knock, http-request!" :: {<!<(order:rudder vase)>}"
    ::  record these in state to be used by %request-local
    ::
    ~&  "secure be {<=/(order !<(order:rudder vase) secure.order)>}"
    ~&  "address be {<=/(order !<(order:rudder vase) address.order)>}"
    ~&  "method.request:http be {<=/(order !<(order:rudder vase) method.request.order)>}"
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
    =/  request
      :^  %'GET'
          url='/focus'
          header-list=~[[key='host' value='localhost'] [key='user-agent' value='Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:108.0) Gecko/20100101 Firefox/108.0'] [key='accept' value='text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8'] [key='accept-language' value='en-US,en;q=0.5'] [key='accept-encoding' value='gzip, deflate, br'] [key='referer' value='http://localhost/focus?rmsg=Processed%20succesfully.'] [key='connection' value='keep-alive'] [key='cookie' value='urbauth-~zod=0v7.ptntr.plr05.mr750.hc4cd.vtjlf'] [key='upgrade-insecure-requests' value='1'] [key='sec-fetch-dest' value='document'] [key='sec-fetch-mode' value='navigate'] [key='sec-fetch-site' value='same-origin'] [key='sec-fetch-user' value='?1']]
          body=~
    ::  =/  cagey  [%handle-http-request !>((order:rudder [~.~.eyre_0v5.ddo5o.lgnk6.v7l84.k6e8c.97sn4 request]))]
    :-
    :~  (~(wait pass:io /focus) setfocus)
        (~(wait pass:io /wrap) setwrap)
        ::  [%request-local secure=? =address =request:http]
        ::
        [%pass /stern %arvo %e %request-local | [%ipv4 .127.0.0.1] request]
        :: (~(poke-self pass:io /stern) cagey)
    ==
    %=  this
      reps.groove  (dec reps.groove)
      then  [setfocus setwrap]
      mode.state-p  %focus
    ==
    ::
      %wrap
    ?>  ?=([%behn %wake *] sign)
    ~&  'wrap up'
    `this
    ::
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
