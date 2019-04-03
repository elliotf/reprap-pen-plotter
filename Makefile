all: render

# render: renders/$(1)
# 

define test_template

render: renders/$(1)

renders/$(1) : for_render/$(1).scad
	openscad -m make -o $$@.stl $$^

.PHONY : renders/$(1)

endef

# Auto detect the tests (any .c file in the test directory),
# and store the list of tests names.
scads := $(foreach scad, $(wildcard for_render/*.scad),$(patsubst %.scad,%,$(notdir $(scad))))

# Add information about each test to the Makefile.
$(foreach scad, $(scads), $(eval $(call test_template,$(scad))))
