# focus
an urbit interval timer. 

evenly space out time for **focus** with time for **rest**.  
receive a "**wrap** up" call for each period.  
run through as many **repititions** as you wish.

I built this to time out my work sessions, meditations, and exercises.

### screenshots
![urbit-timer-screenshots](https://user-images.githubusercontent.com/42229058/211255392-a66f36bd-3e17-4d0a-86d5-4f4613246a54.jpg)

## built for urbit
this app was built entirely with the hoon language for [urbit](https://urbit.org/) in participation of the 2022 end of the year [hackathon](https://encodeclub.notion.site/Encode-x-Urbit-Hackathon-27deac8200a2452ab68574d914728975).

while the backend is obviously written in hoon, the frontend is completely written in hoon as well. **focus** uses the domain-specific language [sail](https://developers.urbit.org/guides/additional/sail) to create html in concert with the [rudder](https://github.com/Fang-/suite/blob/master/lib/rudder.hoon) framework for routing & serving simple web frontends.
 

*the very helpful [sailbox](https://developers.urbit.org/guides/additional/sail) taught me much of this approach, alongside the thoroughly annotated [rudder library and examples](https://github.com/Fang-/suite/tree/master/lib/rudder).*

## this app kills 99.99% of javascript
writing *basically* in 100% hoon, is a wonderful experiece. using hoon for scripting with sail and rudder can get you really far without javascript. but there are some difficult problems to solve. hopefully there are a few decent ideas within **focus** for these sticky situations in a fullstack hoon app.

most difficult challenges
1. inserting strings into tape blocks for dynamically changing css.  
   *there could be an answer for this but I couldn't find it. instead I could only inject numbers dynamically.*
   
2. managing state for manipulating the pages rudder facilitates.  
   *because of the rapidly growing need for state for the frontend, I ended up nesting a larger state-p into my state-0.*  
   
3. page refreshing +on-arvo or trigged from anywhere other than an http post.  
   *for the behn wake gift of my timers to have effects I brought rudder into +on-arvo, with limited success.*
   
4. inacting animations/changes after the page load.  
   *this is where my 3 lines of javascript come in, but maybe I could have done that with css or scss.*

## test and install
a publically visible version lives at [moon.howm.art/focus](https://moon.howm.art/focus).  
on urbit, anyone will be able to install %focus from ~sogtux-bolmel-nordus-mocwyl.  
*you may wish to wait until it's not a wip.*

### try on brave and firefox
the best experiece is on brave/chrome browser.  
while I mostly developed on firefox, it has more strict prevention of autoplay for audio.  
*but if you can grant permission for autoplay on firefox, the visual animations are more consistent there.*

## wip
 there are many things to tweak on the app. even a few core things.  
  -  repititions don't refresh the clock face
  -  the timing of animations get messed up because of german notation
  -  there is no sound for the **wrap-up** calls

still building...
 - viable backend and frontend built dec 20-22
 - frontend and aesthetics crafted jan 2-6
 - submitted for the hackathon jan 8
 
 
 ### paper design from dec 8

![Urbit Timer](https://user-images.githubusercontent.com/42229058/211251605-112fc2be-9594-4c06-9a5d-bc4f04e0a028.jpg)
