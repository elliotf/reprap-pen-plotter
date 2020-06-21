all: render

define render_template

render: renders/$(1)

renders/$(1) : for_render/$(1).scad
	openscad-nightly -m make -o $$@.stl $$^ && echo $$^

.PHONY : renders/$(1)

endef

render_scads := $(foreach scad, $(wildcard for_render/*.scad),$(patsubst %.scad,%,$(notdir $(scad))))

$(foreach scad, $(render_scads), $(eval $(call render_template,$(scad))))






define render_simpler_template

simpler: simpler/renders/$(1)

simpler/renders/$(1) : simpler/$(1).scad
	openscad-nightly -m make -o $$@.stl $$^ && echo $$^

.PHONY : simpler/renders/$(1)

endef

simpler_scads := $(foreach scad, $(wildcard simpler/*.scad),$(patsubst %.scad,%,$(notdir $(scad))))

$(foreach scad, $(simpler_scads), $(eval $(call render_simpler_template,$(scad))))







trial: trial-end trial-carriage trial-motor-mount trial-motor-mount-brace
	
trial-end:
	openscad-nightly -m make -o trial/trial-end.stl trial/trial-end.scad

trial-carriage:
	openscad-nightly -m make -o trial/trial-carriage.stl trial/trial-carriage.scad

trial-motor-mount:
	openscad-nightly -m make -o trial/motor-mount.stl for_render/motor-mount-right.scad

trial-motor-mount-brace:
	openscad-nightly -m make -o trial/motor-mount-brace.stl for_render/motor-mount-brace-right.scad






define render_twomotor_template

twomotor: twomotor/renders/$(1)

twomotor/renders/$(1) : twomotor/$(1).scad
	openscad-nightly -m make -o $$@.stl $$^ && echo $$^

.PHONY : twomotor/renders/$(1)

endef

twomotor_scads := $(foreach scad, $(wildcard twomotor/*.scad),$(patsubst %.scad,%,$(notdir $(scad))))

$(foreach scad, $(twomotor_scads), $(eval $(call render_twomotor_template,$(scad))))
