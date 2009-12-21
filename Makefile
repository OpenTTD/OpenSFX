# Makefile for OpenSFX set

MAKEFILELOCAL=Makefile.local
MAKEFILECONFIG=Makefile.config

SHELL = /bin/sh

# Add some OS detection and guess an install path (use the system's default)
OSTYPE=$(shell uname -s)
ifeq ($(OSTYPE),Linux)
INSTALLDIR=$(HOME)/.openttd/data
else
ifeq ($(OSTYPE),Darwin)
INSTALLDIR=$(HOME)/Documents/OpenTTD/data
else
ifeq ($(shell echo "$(OSTYPE)" | cut -d_ -f1),MINGW32)
INSTALLDIR=C:\Documents and Settings\$(USERNAME)\My Documents\OpenTTD\data
else
INSTALLDIR=
endif
endif
endif

# define a few repository references used also in makefile.config
CAT_REVISION = $(shell hg parent --template="{rev}\n")
CAT_MODIFIED = $(shell [ -n "`hg status '.' | grep -v '^?'`" ] && echo "M" || echo "")
REPO_TAGS    = $(shell hg parent --template="{tags}" | grep -v "tip" | cut -d\  -f1)

include ${MAKEFILECONFIG}

# OS detection: Cygwin vs Linux
ISCYGWIN = $(shell [ ! -d /cygdrive/ ]; echo $$?)
CATCODEC = $(shell [ \( $(ISCYGWIN) -eq 1 \) ] && echo catcodec.exe || echo catcodec)

# this overrides definitions from above:
-include ${MAKEFILELOCAL}

CAT_FILENAME   = $(addsuffix .$(CAT_SUFFIX),$(FILENAME))
SFO_FILENAME   = $(addsuffix .$(SFO_SUFFIX),$(FILENAME))
DIR_BASE       = $(FILENAME)-
VERSION_STRING = $(shell [ -n "$(REPO_TAGS)" ] && echo $(REPO_TAGS)$(CAT_MODIFIED) || echo $(CAT_NIGHTLYNAME)-r$(CAT_REVISION)$(CAT_MODIFIED))
DIR_NAME       = $(shell [ -n "$(REPO_TAGS)" ] && echo $(DIR_BASE)$(VERSION_STRING) || echo $(DIR_BASE)$(CAT_NIGHTLYNAME))
DIR_NAME_SRC   = $(DIR_BASE)$(VERSION_STRING)-source
# Tarname has no version: overwrite for make install
TAR_FILENAME   = $(DIR_NAME).$(TAR_SUFFIX)
# The release filenames bear the version being built.
ZIP_FILENAME   = $(DIR_BASE)$(VERSION_STRING).$(ZIP_SUFFIX)
BZIP_FILENAME  = $(DIR_BASE)$(VERSION_STRING).$(BZIP2_SUFFIX)

REPO_DIRS    = $(dir $(BUNDLE_FILES))

-include ${MAKEFILELOCAL}

vpath
vpath %.pfno $(SRCDIR)
vpath %.nfo $(SRCDIR)

.PHONY: clean all bundle bundle_tar bundle_zip bundle_bzip install release release_zip remake test

# Now, the fun stuff:

# Target for all:
all : $(OBS_FILE)

test :
	$(_E) "Call of catcodec:             $(CATCODEC) $(CATCODEC_FLAGS)"
	$(_E) "Local installation directory: $(INSTALLDIR)"
	$(_E) "Repository revision:          r$(CAT_REVISION)"
	$(_E) "CAT title:                    $(CAT_TITLE)"
	$(_E) "CAT filenames:                $(CAT_FILENAME)"
	$(_E) "Documentation filenames:      $(DOC_FILENAMES)"
	$(_E) "sfo files:                    $(SFO_FILENAME)"
	$(_E) "dep files:                    $(DEP_FILENAMES)"
	$(_E) "Bundle files:                 $(BUNDLE_FILES)"
	$(_E) "Bundle filenames:             Tar=$(TAR_FILENAME) Zip=$(ZIP_FILENAME) Bz2=$(BZIP_FILENAME)"
	$(_E) "Dirs (base and full):         $(DIR_BASE) / $(DIR_NAME)"
	$(_E) "Path to Unix2Dos:             $(UNIX2DOS)"
	$(_E) "===="

$(OBS_FILE) : $(SRCDIR)/$(CAT_FILENAME) $(DESC_FILENAME) $(README_FILENAME) $(CHANGELOG_FILENAME) $(LICENSE_FILENAME)
	$(_E) "[Generating:] $(OBS_FILE)"
	@echo "[metadata]" > $(OBS_FILE)
	@echo "name        = $(CAT_NAME)" >> $(OBS_FILE)
	@echo "shortname   = $(CAT_SHORTNAME)" >> $(OBS_FILE)
	@echo "version     = $(CAT_REVISION)" >> $(OBS_FILE)
	@echo "description = $(CAT_DESCRIPTION) [$(CAT_TITLE)]" >> $(OBS_FILE)

	@echo "" >> $(OBS_FILE)
	@echo "[files]" >> $(OBS_FILE)
	@echo "samples     = $(CAT_FILENAME)" >> $(OBS_FILE)

	@echo "" >> $(OBS_FILE)
	@echo "[md5s]" >> $(OBS_FILE)
	@echo "$(CAT_FILENAME) = "`$(MD5SUM) $(SRCDIR)/$(CAT_FILENAME) | cut -f1 -d\  ` >> $(OBS_FILE)

	@echo "" >> $(OBS_FILE)
	@echo "[origin]" >> $(OBS_FILE)
	@echo "$(CAT_ORIGIN)" >> $(OBS_FILE)
	$(_E) "[Done] Basesound successfully generated."
	$(_E) ""

%.$(DEP_SUFFIX) : $(SRCDIR)/%.$(SFO_SUFFIX)
	$(_E) "[Depend] $(@:$(DEP_SUFFIX)=$(CAT_SUFFIX))"
	$(_V) grep "wav" $< | cut -f1 -d\  | sed 's@"@@g;s@^@$(<) $(@:%.$(DEP_SUFFIX)=$(SRCDIR)/%.$(CAT_SUFFIX)) : @' | sort | uniq > $@

#"
# Compile CAT
%.$(CAT_SUFFIX) : %.$(SFO_SUFFIX)
	$(_E) "[Generating] $@"
	$(_V)$(CATCODEC) $(CATCODEC_FLAGS) $@
	$(_E)

# NFORENUM process copy of the NFO
.SECONDARY: %.$(SFO_SUFFIX)
.PRECIOUS: %.$(SFO_SUFFIX)

# Clean the source tree
clean:
	$(_E) "[Cleaning]"
	$(_V)-rm -rf *.orig *.pre *.bak *.cat *~ $(FILENAME).* $(DEP_FILENAMES) $(SRCDIR)/$(CAT_FILENAME) $(SRCDIR)/*.bak

mrproper: clean
	$(_V)-rm -rf $(DIR_BASE)* $(SRCDIR)/$(CAT_FILENAME) $(OBS_FILE) $(DIR_NAME_SRC)

$(DIR_NAME) : $(BUNDLE_FILES)
	$(_E) "[BUNDLE]"
	$(_E) "[Generating:] $@/."
	$(_V)if [ -e $@ ]; then rm -rf $@; fi
	$(_V)mkdir $@
	$(_V)-for i in $(BUNDLE_FILES); do cp $$i $@; done
bundle: $(DIR_NAME)

#%.$(TXT_SUFFIX): %.$(PTXT_SUFFIX)
#	$(_E) "[Generating:] $@"
#	$(_V) cat $< \
#		| sed -e "s/$(CAT_TITLE_DUMMY)/$(CAT_TITLE)/" \
#		| sed -e "s/$(OBS_FILE_DUMMY)/$(OBS_FILE)/" \
#		| sed -e "s/$(REVISION_DUMMY)/$(CAT_REVISION)/" \
#		> $@

%.$(TAR_SUFFIX): % $(BUNDLE_FILES)
# Create the release bundle with all files in one tar
	$(_E) "[Generating:] $@"
	$(_V)$(TAR) $(TAR_FLAGS) $@ $(basename $@)
	$(_E)

bundle_tar: $(TAR_FILENAME)
bundle_zip: $(ZIP_FILENAME)
$(ZIP_FILENAME): $(DIR_NAME)
	$(_E) "[Generating:] $@"
	$(_V)$(ZIP) $(ZIP_FLAGS) $@ $^
bundle_bzip: $(BZIP_FILENAME)
$(BZIP_FILENAME): $(TAR_FILENAME)
	$(_E) "[Generating:] $@"
	$(_V)$(BZIP) $(BZIP_FLAGS) $^

# Installation process
install: $(TAR_FILENAME) $(INSTALLDIR)
	$(_E) "[INSTALL] to $(INSTALLDIR)"
	$(_V)-cp $(TAR_FILENAME) $(INSTALLDIR)
	$(_E)

bundle_src:
	$(_V) rm -rf $(DIR_NAME_SRC)
	$(_V) mkdir -p $(DIR_NAME_SRC)
	$(_V) cp -R $(SRCDIR) $(DOCDIR) Makefile Makefile.config $(DIR_NAME_SRC)
	$(_V) cp Makefile.local.sample $(DIR_NAME_SRC)/Makefile.local
	$(_V) echo 'CAT_REVISION = $(CAT_REVISION)' >> $(DIR_NAME_SRC)/Makefile.local
	$(_V) echo 'CAT_MODIFIED = $(CAT_MODIFIED)' >> $(DIR_NAME_SRC)/Makefile.local
	$(_V) echo 'REPO_TAGS    = $(REPO_TAGS)'    >> $(DIR_NAME_SRC)/Makefile.local
	$(_V) $(MAKE) -C $(DIR_NAME_SRC) mrproper
	$(_V) $(TAR) --gzip -cf $(DIR_NAME_SRC).tar.gz $(DIR_NAME_SRC)
	$(_V) rm -rf $(DIR_NAME_SRC)


$(INSTALLDIR):
	$(_E) "$(error Installation dir does not exist. Check your makefile.local)"

release-install:
	$(_E) "Target is obsolete. Use 'install' instead."
release-source:
	$(_E) "Target is obsolete. Use 'bundle_src' instead."
release_zip:
	$(_E) "Target is obsolete. Use 'bundle_zip' instead."

remake: clean all
