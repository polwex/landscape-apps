/-  g=groups
|%
++  enjs
  =,  enjs:format
  |%
  ++  ship
    |=  her=@p
    s/(scot %p her)
  ::
  ++  update
    |=  =update:g
    %-  pairs
    :~  time+s+(scot %ud p.update)
        diff+(diff q.update)
    ==
  ::
  ++  diff
    |=  d=diff:g
    %+  frond  -.d
    ?-    -.d
      %fleet    (pairs ship/(ship p.d) diff/(fleet-diff q.d) ~)
      %channel  (pairs flag/s/(flag p.d) diff/(channel-diff q.d) ~)
      %cabal    (pairs sect/s/p.d diff/(cabal-diff q.d) ~)
      %cordon   (cordon-diff p.d)
      %create   (group p.d)
    ==
  ::
  ++  cordon-diff
    |=  d=diff:cordon:g
    %+  frond  -.d
    s/p.d
  ::
  ++  channel-diff
    |=  d=diff:channel:g
    %+  frond  -.d
    ?-  -.d
      %add  (channel channel.d)
      %del  ~
      ?(%add-sects %del-sects)  a/(turn ~(tap in sects.d) (lead %s))
    ==
  ::
  ++  cabal-diff
    |=  d=diff:cabal:g
    %+  frond  -.d
    ?-  -.d
      %add  (meta meta.d)
      %del  ~
    ==
  ::
  ++  fleet-diff
    |=  d=diff:fleet:g
    %+  frond  -.d
    ?-  -.d
      %add  (vessel vessel.d)
      %del  ~
      %add-sects  a/(turn ~(tap in sects.d) (lead %s))
      %del-sects  a/(turn ~(tap in sects.d) (lead %s))
    ==
  ::
  ++  groups
    |=  gs=(map flag:g group:g)
    %-  pairs
    %+  turn  ~(tap by gs)
    |=  [f=flag:g gr=group:g]
    [(flag f) (group gr)]
  ::
  ++  group
    |=  gr=group:g
    %-  pairs
    :~  fleet/(fleet fleet.gr)
        cabals/(cabals cabals.gr)
        channels/(channels channels.gr)
        cordon/(cordon cordon.gr)
        meta/(meta meta.gr)
    ==
  ++  fleet
    |=  fl=fleet:g
    %-  pairs
    %+  turn  ~(tap by fl)
    |=  [her=@p v=vessel:fleet:g]
    ^-  [cord json]
    [(scot %p her) (vessel v)]
  ::
  ++  vessel
    |=  v=vessel:fleet:g
    %-  pairs
    :~  sects/a/(turn ~(tap in sects.v) (lead %s))
        joined/(time joined.v)
    ==
  ++  cabals
    |=  cs=(map sect:g cabal:g)
    %-  pairs
    %+  turn  ~(tap by cs)
    |=  [=term c=cabal:g]
    ^-  [cord json]
    [term (cabal c)]
  ::
  ++  cabal
    |=  c=cabal:g
    %-  pairs
    :~  meta/(meta meta.c)
    ==
  ++  flag
    |=  f=flag:g
    (rap 3 (scot %p p.f) '/' q.f ~)
  ::
  ++  channels
    |=  chs=(map flag:g channel:g)
    %-  pairs
    %+  turn  ~(tap by chs)
    |=  [f=flag:g c=channel:g]
    ^-  [cord json]
    [(flag f) (channel c)]
  ::
  ++  channel
    |=  ch=channel:g
    %-  pairs
    :~  meta/(meta meta.ch)
        added/(time added.ch)
    ==
  ::
  ++  cordon
    |=  c=cordon:g
    %-  pairs
    :~  [-.c ~]
    ==
  ::
  ++  meta
    |=  m=meta:g
    %-  pairs
    :~  title/s/title.m
        description/s/description.m
        image/s/image.m
    ==
  --
::
++  dejs
  =,  dejs:format
  |%
  ++  sym  (se %tas)
  ++  ship  (se %p)
  ++  flag  (su ;~((glue fas) ;~(pfix sig fed:ag) ^sym))
  ++  create
    ^-  $-(json create:g)
    %-  ot
    :~  name+sym
        title+so
        description+so
    ==
  ++  action
    ^-  $-(json action:g)
    %-  ot
    :~  flag+flag
        update+update
    ==
  ++  update
    |=  j=json
    ^-  update:g
    ?>  ?=(%o -.j)
    [*time (diff (~(got by p.j) %diff))]
  ::
  ++  diff
    %-  of
    :~  cabal/(ot sect/sym diff/cabal-diff ~)
        fleet/(ot ship/ship diff/fleet-diff ~)
    ==
  ::
  ++  fleet-diff
    %-  of
    :~  [%add-sects (as sym)]
    ==
  ::
  ++  cabal-diff
    %-  of
    :~  add/meta
        del/ul
    ==
  ::
  ++  meta
    %-  ot
    :~  title/so
        description/so
        image/so
    ==
  --
--