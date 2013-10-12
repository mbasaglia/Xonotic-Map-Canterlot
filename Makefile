#-------------------
# config variables
#-------------------
# MAPNAME 
#	name of the map
# VERSION
#	suffix used on release
# TEXTURE_BLACKLIST
#	list of files in textures/$(MAPNAME) that must not be copiend in the pk3
#-------------------
# targets
#-------------------
# all
#	Compile the map in a bsp
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
#	Compile, rename_link to $(MAPNAME)$(VERSION) and create pk3
# rename
#	Rename files from $(MAPNAME).* to $(NEWNAME).*
# rename_copy
#	Copy files from $(MAPNAME).* to $(NEWNAME).*
# rename_link
#	Link to $(MAPNAME).* from $(NEWNAME).*
# __rename_internal
#	Used by rename, rename_copy, rename_link.

MAPNAME=canterlot
VERSION=_v003

TEXTURE_BLACKLIST= bricks_aligntest.jpg \
		bricks_aligntest_corner.jpg \
		bricks_aligntest_corner1.jpg
		

Q3MAP2_FLAGS= -meta -v
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
MINIMAP=gfx/$(MAPNAME)_mini.tga
TEXTUREDIR=textures/$(MAPNAME)
TEXTURES=$(filter-out $(addprefix $(TEXTUREDIR)/,$(TEXTURE_BLACKLIST)), $(wildcard $(TEXTUREDIR)/*))
SCRIPTS= $(wildcard scripts/*)
DIST_NAME=$(MAPNAME).tar.gz
DIST_FILES=$(filter-out $(DIST_NAME) $(PK3NAME), $(wildcard *))

NEWNAME=$(MAPNAME)
RENAMED_MAP_SOURCE=maps/$(NEWNAME).map
RENAMED_MAP_COMPILED=maps/$(NEWNAME).bsp
RENAMED_MAP_INFO=maps/$(NEWNAME).mapinfo
RENAMED_MAP_SCREENSHOT=maps/$(NEWNAME).jpg
RENAMED_MINIMAP=gfx/$(NEWNAME)_mini.tga
# RENAMED_TEXTUREDIR=textures/$(NEWNAME)
__RENAME_INTERNAL_FILE_ACTION=echo

.SUFFIXES: .bsp .map
.PHONY: clean dist pk3 rename rename_copy __rename_internal release


all: $(MAP_COMPILED)

dist:
	$(REMOVE_FILE) $(DIST_NAME)
	tar -caf $(DIST_NAME) $(DIST_FILES)

pk3: $(MAP_COMPILED)
pk3: $(MINIMAP)
pk3:
	$(REMOVE_FILE) $(PK3NAME)
	$(PK3_ADD) $(TEXTURES) $(SCRIPTS) $(MAP_COMPILED) $(MINIMAP) $(MAP_SOURCE) $(MAP_INFO) $(MAP_SCREENSHOT)

clean:
	$(REMOVE_FILE) $(PK3NAME) $(DIST_NAME)

%.bsp : %.map
	$(Q3MAP2) $(Q3MAP2_FLAGS) $(MAP_SOURCE) $*

gfx/%_mini.tga : %.bsp
	$(Q3MAP2) -minimap -o gfx/$*_mini.tga $(MAP_COMPILED)


rename: __RENAME_INTERNAL_FILE_ACTION=$(RENAME_FILE)
rename: __rename_internal
rename:

rename_copy: __RENAME_INTERNAL_FILE_ACTION=$(COPY_FILE)
rename_copy: __rename_internal
rename_copy:

rename_link: __RENAME_INTERNAL_FILE_ACTION=$(LINK_FILE)
rename_link: __rename_internal
rename_link:

__rename_internal: $(MAP_SOURCE)
__rename_internal: $(MAP_COMPILED)
__rename_internal: $(MAP_INFO)
__rename_internal: $(MAP_SCREENSHOT)
__rename_internal: $(MINIMAP)
__rename_internal:
	$(__RENAME_INTERNAL_FILE_ACTION) $(notdir $(MAP_SOURCE))     $(RENAMED_MAP_SOURCE)
	$(__RENAME_INTERNAL_FILE_ACTION) $(notdir $(MAP_COMPILED))   $(RENAMED_MAP_COMPILED)
	$(__RENAME_INTERNAL_FILE_ACTION) $(notdir $(MAP_INFO))       $(RENAMED_MAP_INFO)
	$(__RENAME_INTERNAL_FILE_ACTION) $(notdir $(MAP_SCREENSHOT)) $(RENAMED_MAP_SCREENSHOT)
	$(__RENAME_INTERNAL_FILE_ACTION) $(notdir $(MINIMAP))        $(RENAMED_MINIMAP)

release: $(MAP_COMPILED)
release: $(MINIMAP)
release:
	make rename_link NEWNAME=$(MAPNAME)$(VERSION)
	make pk3 MAPNAME=$(MAPNAME)$(VERSION) TEXTUREDIR=$(TEXTUREDIR)