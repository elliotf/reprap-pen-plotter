# TODO

* make y carriage get pulled by center of mass
  * lower X rail
  * move x limit switches to z axis
    * all wiring could come from z axis!
  * or just stop faffing around get some sort of plotter done?
* pulleys
  * idler
    * print a bevel to put the idler pulley at/near the correct height?
    * switch to 625 or MR105 bearing?
      * MR105 would mean an easier to print idler pulley; going with this for now
      * 625 would mean we could use all the same bearings; grooved bearings would fit inside a 625 cavity
        * 8 grooved + 6 (optionally) non-grooved
      * use an m5 bolt instead of smooth rod
        * moving forward with this, but need to adjust motor brace for bolt head
        * easier to get a given length?
        * could screw in, so a clamp wouldn't be necessary?
        * makes the brace a little harder?
          * would need to have an accurately-ish sized m5 bolt head hole
        * fewer different vitamins
          * could use the same length m5 bolts for the rear idlers
* guitar tuner tensioner
  * has a screw-in collar that I forgot about, so the acute angle will make it difficult to assemble
    * maybe not use the collar? It seems to be fine without it?
* make it easier to assemble
  * make motor idler shaft hole larger and make some sort of screw-down clamp?
    * no, using a bolt instead of a shaft
  * make it easier to slide extrusions into carriages
    * the spring design is at least 5x easier
* use correct diameter for brass threaded inserts
  * measured inserts, but need to validate sizes w/a test print and test insertion
  * m2
  * m2.5
  * m3 (done? which inserts do we want to use?)

## wiring
* Power
  * 19v-24v power supply feeds arduino CNC shield
  * runs to a DC-DC 5v converter to power Raspberry Pi
    * https://www.amazon.com/dp/B0758ZTS61 ?
  * power arduino via Raspberry Pi USB (kind of a fail, but meh)
    * could also run a second DC-DC converter?
  * cat5/cat6 for X carriage?
    * 2+ pair for stepper
    * 1 5v DC
    * Z limit signal
    * X limit signal
    * 1+ Ground

## TODONE
* mounts for wire support zip ties (partially now)
  * anchor z mount to y carriage, then y carriage to electronics, or direct from z mount to electronics?
    * solved with mounting holes on x and y carriages, should be flexible enough
  * long zip ties that I bought were very floppy.  :(
    * alternatives -- tubing?
      * HDPE refrigerator line tubing?
      * 4mm ID, 6mm OD PTFE ?
      * it'd be nice to have lateral stiffness, though.  :(
    * alternatives -- plastic sheeting?
      * strips of HDPE plastic?
* motor mounts (done)
  * and motor mount positioning (mostly)
  * holes to screw motor mount to extrusion (done)
* endstop mounting (done, sort of)
  * z max on the z carrier?
    * how to do fine adjustments so that it triggers close to the top of travel?
  * x min/max on the X carriage (done)
    * have X endstop hit something screwed into the extrusion? (done)
  * y on the motor/idler mounts (done)
  * for_render/* for endstop flags
* base plate (done)
  * add it to the Makefile
  * and ways to anchor motors/idler mounts to base (done)

## YAGNI
* compensate for spectra line diameter
  * 0.6 probably doesn't matter
    * and likely only the motor position is affected?
* angle contact point with z axis lifter to control acceleration?
  * rather than smacking the pen into the writing surface?
