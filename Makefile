#-------------------
# config variables
#-------------------
# MAPNAME 
#	name of the map
# VERSION
#	suffix used on release
# TEXTURE_BLACKLIST
#	list of files in textures that must not be copiend in the pk3
# EXTRA_FILES_RENAME
#	additional files that will be added to the pk3 and renamed by rename* targets
# EXTRA_DIRS
#	additional directories that will be recursively added to the pk3
#-------------------
# q3map2 options
#-------------------
# BASEPATH
#	Game installation directory
# HOMEPATH
#	Game user directory
# Q3MAP2
#	Command used to compile the map
# Q3MAP2_FLAGS
#	Global flags
# Q3MAP2_FLAGS_BSP
#	Flags used during the bsp pass
# Q3MAP2_FLAGS_VIS
#	Flags used during the -vis pass
# Q3MAP2_FLAGS_LIGHT
#	Flags used during the -light pass
#-------------------
# targets
#-------------------
# all
#	Compile the map in a bsp
# bsp_vis
#	Compile -vis pass
# bsp_light
#	Compile -light pass
# bsp_full
#	Compile with -vis and -light passes
# dist
#	Make a tarball containing all files in the current directory
# pk3
#	Compile bsp and minimap, then create a pk3 containing all the release files
# clean
#	Remove the files created by dist and pk3
# %.bsp
#	Compile a bsp from a map
# gfx/%_mini.tga
#	Compile a minimap from a map
# release
#	Compile (only bsp), rename_link to $(MAPNAME)$(VERSION) and create pk3
# release_compile
#	Compile (bsp_full), rename_link to $(MAPNAME)$(VERSION) and create pk3
# release_nocompile
#	Does not perform directly any compilation
# bump_nocompile
#	Touches files in order to avoid recompilation
# rename
#	Rename files from $(MAPNAME).* to $(NEWNAME).*
# rename_copy
#	Copy files from $(MAPNAME).* to $(NEWNAME).*
# rename_link
#	Link to $(MAPNAME).* from $(NEWNAME).*
# __rename_internal
#	Used by rename, rename_copy, rename_link.

MAPNAME=canterlot
VERSION=_v005

BASEPATH=$(HOME)/share/Xonotic/
HOMEPATH=$(HOME)/.xonotic/

TEXTURE_BLACKLIST= work_files
EXTRA_DIRS=
EXTRA_FILES_RENAME=maps/$(MAPNAME).rtlights

Q3MAP2_FLAGS_EXTRA=
Q3MAP2_FLAGS= -v -connect 127.0.0.1:39000 -game xonotic -fs_basepath "$(BASEPATH)" -fs_homepath "$(HOMEPATH)" -fs_game data $(Q3MAP2_FLAGS_EXTRA)
Q3MAP2_FLAGS_BSP= -meta -v
Q3MAP2_FLAGS_VIS= -vis -saveprt
Q3MAP2_FLAGS_LIGHT= -light -fast
Q3MAP2=q3map2

PK3_ADD=zip -p $(PK3NAME)
REMOVE_FILE=rm -f
RENAME_FILE=mv -T 
COPY_FILE=cp -T
LINK_FILE=ln -s -f -T

PK3NAME=$(MAPNAME).pk3
MAP_SOURCE=maps/$(MAPNAME).map
MAP_COMPILED=maps/$(MAPNAME).bsp
MAP_INFO=maps/$(MAPNAME).mapinfo
MAP_SCREENSHOT=maps/$(MAPNAME).jpg
MAP_WAYPOINTS=maps/$(MAPNAME).waypoints
MINIMAP=gfx/$(MAPNAME)_mini.tga
TEXTUREDIR=textures
TEXTURES=$(filter-out $(addprefix $(TEXTUREDIR)/,$(TEXTURE_BLACKLIST)), $(wildcard $(TEXTUREDIR)/*))
SCRIPTS= $(wildcard scripts/*)
DIST_NAME=$(MAPNAME).tar.gz
DIST_FILES=$(filter-out $(DIST_NAME) $(PK3NAME), $(wildcard *))

NEWNAME=$(MAPNAME)
FILES_RENAME=$(MAP_SOURCE) $(MAP_COMPILED) $(MAP_INFO) $(MAP_SCREENSHOT) $(MINIMAP) $(EXTRA_FILES_RENAME)
__RENAME_INTERNAL_FILE_ACTION=echo

.SUFFIXES: .bsp .map
.PHONY: clean dist pk3 rename rename_copy __rename_internal release bsp bsp_full bsp_vis bsp_light bump_nocompile release_nocompile release_compile __release_internal


all: $(MAP_COMPILED)

dist:
	$(REMOVE_FILE) $(DIST_NAME)
	tar -caf $(DIST_NAME) $(DIST_FILES)

pk3: $(MAP_COMPILED)
pk3: $(MINIMAP)
pk3:
	$(REMOVE_FILE) $(PK3NAME)
	$(PK3_ADD) $(SCRIPTS) $(MAP_COMPILED) $(MINIMAP) $(MAP_SOURCE) $(MAP_INFO) $(MAP_SCREENSHOT) $(EXTRA_FILES_RENAME)
	$(PK3_ADD) -r $(TEXTURES) $(EXTRA_DIRS)

clean:
	$(REMOVE_FILE) $(PK3NAME) $(DIST_NAME)

$(MAP_COMPILED) : $(MAP_SOURCE)
	$(Q3MAP2) $(Q3MAP2_FLAGS) $(Q3MAP2_FLAGS_BSP) $(MAP_SOURCE)

#TODO: remove this and add proper dependencies to scripts and textures
bsp:
	$(Q3MAP2) $(Q3MAP2_FLAGS) $(Q3MAP2_FLAGS_BSP) $(MAP_SOURCE)

bsp_vis: $(MAP_COMPILED)
bsp_vis:
	$(Q3MAP2) $(Q3MAP2_FLAGS) $(Q3MAP2_FLAGS_VIS)   $(MAP_SOURCE)
bsp_light: $(MAP_COMPILED)
bsp_light:
	$(Q3MAP2) $(Q3MAP2_FLAGS) $(Q3MAP2_FLAGS_LIGHT) $(MAP_SOURCE)

bsp_full: bsp
bsp_full: bsp_vis
bsp_full: bsp_light
bsp_full:

$(MINIMAP) : $(MAP_COMPILED)
	$(Q3MAP2) -minimap -o $(MINIMAP) $(MAP_COMPILED)


rename: __RENAME_INTERNAL_FILE_ACTION=$(RENAME_FILE)
rename: __rename_internal
rename:

rename_copy: __RENAME_INTERNAL_FILE_ACTION=$(COPY_FILE)
rename_copy: __rename_internal
rename_copy:

rename_link: __RENAME_INTERNAL_FILE_ACTION=$(LINK_FILE)
rename_link: __rename_internal
rename_link:

__rename_internal: $(FILES_RENAME)
__rename_internal:
	$(foreach file, $(FILES_RENAME), $(__RENAME_INTERNAL_FILE_ACTION) $(notdir $(file)) $(subst $(MAPNAME),$(NEWNAME),$(file));)
	
	
release_compile: $(MAP_COMPILED)
release_compile: $(MINIMAP)
release_compile: bsp_full
release_compile: __release_internal
release_compile:

release: $(MAP_COMPILED)
release: $(MINIMAP)
release: __release_internal
release:

release_nocompile: bump_nocompile
release_nocompile: __release_internal
release_nocompile:
	
__release_internal:
	make rename_link NEWNAME=$(MAPNAME)$(VERSION)
	make pk3 MAPNAME=$(MAPNAME)$(VERSION)

bump_nocompile:
	touch $(MAP_COMPILED)
	touch $(MINIMAP)

define AUTO_MAPINFO
title $(MAPNAME)
// description ...
// author ...
cdtrack 7
// has weapons
// has turrets
// has vehicles
gametype dm
gametype lms
gametype ka
gametype kh
gametype ca
gametype tdm
gametype ft
// optional: fog density red green blue alpha mindist maxdist
// optional: settemp_for_type (all|gametypename) cvarname value
// optional: clientsettemp_for_type (all|gametypename) cvarname value
// optional: size mins_x mins_y mins_z maxs_x maxs_y maxs_z
// optional: hidden
endef
export AUTO_MAPINFO
$(MAP_INFO):
	echo "$$AUTO_MAPINFO" >$(MAP_INFO)
