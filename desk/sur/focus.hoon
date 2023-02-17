/+  rudder
|%
+$  focus  @dr
+$  wrap  @ud  :: signal before time ends
+$  reps  @ud
+$  rest  @dr
+$  wrep  @ud  :: wrap for the rest periods
+$  gruv  [=focus =wrap =reps =rest =wrep]
::
+$  then  [time=@da wrap=@da]
+$  left  [@dr @dr]
::
+$  public  ?
::
+$  display  ?(%form %help %clock %goals %enter)
+$  mode  ?(%fin %rest %focus)
+$  prev-cmd  ?(%begin %pause %cont %fresh)
+$  reveal  ?
+$  state-p  [=display =mode =reveal =prev-cmd]
::  for %goals
::
+$  pin  [owner=@p birth=@da]
+$  goals  [pool=pin groove=pin reps=pin]
::
::  type unions are eating my lunch!
::    disaplyify was made to help out.
::
++  displayify
  |=  incoming=@tas
  %-  display  incoming
::
::  is there a good non-cell way to do this
::  most of these commands could just be @tas
::  begin, focus, rest, fin, pause, cont, deliver
::
+$  command
  $%  [%pause ?]
      [%cont ?]
      [%reveal reveal]
      [%public public=?]
      [%maneuver =gruv =display]
      [%sub =pin]
  ==
::
+$  update
  $%  command
      [%blank def=gruv]
  ==
::  state for rudder, a copy of +.state-0
::  +$  state-0  [%0 groove=gruv =reps =then =left =state-p =pool =public]
::
+$  tack  [groove=gruv =reps =then left state-p goals public]
--
