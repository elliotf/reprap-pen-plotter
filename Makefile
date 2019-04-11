all: render

define test_template

render: renders/$(1)

renders/$(1) : for_render/$(1).scad
	openscad-nightly -m make -o $$@.stl $$^

.PHONY : renders/$(1)

endef

scads := $(foreach scad, $(wildcard for_render/*.scad),$(patsubst %.scad,%,$(notdir $(scad))))

$(foreach scad, $(scads), $(eval $(call test_template,$(scad))))

trial: trial-end trial-carriage trial-motor-mount trial-motor-mount-brace
	
trial-end:
	openscad-nightly -m make -o trial/trial-end.stl trial/trial-end.scad

trial-carriage:
	openscad-nightly -m make -o trial/trial-carriage.stl trial/trial-carriage.scad

trial-motor-mount:
	openscad-nightly -m make -o trial/motor-mount.stl for_render/motor-mount-right.scad

trial-motor-mount-brace:
	openscad-nightly -m make -o trial/motor-mount-brace.stl for_render/motor-mount-brace-right.scad
