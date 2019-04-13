# TODO

* use correct diam for idler shafts
  * make a tighter fit for m5 to thread into
* make it easier to assemble
  * make motor idler shaft hole larger and make some sort of screw-down clamp
  * make it easier to slide extrusions into carriages
    * fewer bushings?
      * two on one side, one on the other rather than two on each?
* use correct diameter for brass threaded inserts
  * m2
  * m2.5
  * m3 (done? which inserts do we want to use?)
* mounts for wire support zip ties (partially now)
  * anchor z mount to y carriage, then y carriage to electronics, or direct from z mount to electronics?
    * solved with mounting holes on x and y carriages, should be flexible enough
  * long zip ties that I bought were very floppy.  :(
* motor mounts (done)
  * and motor mount positioning (mostly)
  * holes to screw motor mount to extrusion (done)
* endstop mounting
  * z max on the z carrier?
    * how to do fine adjustments so that it triggers close to the top of travel?
  * x min/max on the X carriage (done)
    * have X endstop hit something screwed into the extrusion? (done)
  * y on the motor/idler mounts (done)
  * for_render/* for endstop flags
* base plate (done)
  * add it to the Makefile
  * and ways to anchor motors/idler mounts to base (done)
* compensate for spectra line diameter
  * 0.6 probably doesn't matter
    * and likely only the motor position is affected?
* angle contact point with z axis lifter to control acceleration?
  * rather than smacking the pen into the writing surface?

## wiring
* Power
  * 19v-24v power supply feeds arduino CNC shield
  * runs to a DC-DC 5v converter to power Raspberry Pi
    * https://www.amazon.com/dp/B0758ZTS61 ?
  * power arduino via Raspberry Pi USB (kind of a fail, but meh)
    * could also run a second DC-DC converter?
