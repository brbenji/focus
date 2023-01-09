::  additional types for potentail expansion
::  +$  ease  @dr  :: def ~s4 before focus begins, a delay on begin
::  +$  name  @t
::
|%
+$  focus  @dr
+$  wrap  @ud  :: signal before time ends
+$  reps  @ud
+$  rest  @dr
+$  wrep  @ud  :: wrap for the rest periods
+$  gruv  [=focus =wrap =reps =rest =wrep]
::
+$  then  [@da @da]
::
+$  display  ?(%form %help %clock %enter)
+$  mode  ?(%fin %rest %focus)
+$  prev-cmd  ?(%begin %pause %cont %fresh)
+$  begin  ?
+$  state-p  [=display =mode =prev-cmd =begin]
::  type unions are eating my lunch!
::    disaplyify was made to help out.
::
++  displayify
  |=  incoming=@tas
  %-  display  incoming
::
+$  command
  $%  [%maneuver =gruv =display =begin]
      [%pause ?]
      [%cont ?]
      [%focus =gruv]
      [%rest =gruv]
  ==
::
+$  update
  $%  command
      [%blank def=gruv]
  ==
::  state for rudder, a copy of +.state-0
::
+$  tack  [groove=gruv =reps then state-p]
--
