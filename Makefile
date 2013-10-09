
MAPNAME=canterlot

TEXTURE_BLACKLIST= bricks_aligntest.jpg \
		bricks_aligntest_corner.jpg \
		bricks_aligntest_corner1.jpg
		

Q3MAP2_FLAGS= -meta -v
Q3MAP2=/home/bazzy/Documents/misc/Xonotic/xonotic/netradiant/install/q3map2

PK3_ADD=zip -p $(PK3NAME)
REMOVE_FILE=rm -f

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

.SUFFIXES: .bsp .map
.PHONY: clean


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