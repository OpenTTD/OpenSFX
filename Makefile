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

CAT_REVISION = $(shell hg parent --template="{rev}\n")

include ${MAKEFILECONFIG}

# OS detection: Cygwin vs Linux
ISCYGWIN = $(shell [ ! -d /cygdrive/ ]; echo $$?)
CATCODEC = $(shell [ \( $(ISCYGWIN) -eq 1 \) ] && echo catcodec.exe || echo catcodec)

# this overrides definitions from above:
CAT_MODIFIED = $(shell [ -n "`hg status \"." | grep -v '^?'`" ] && echo "M" || echo "")
# " \" (syntax highlighting line
REPO_TAGS    = $(shell hg parent --template="{tags}" | grep -v "tip" | cut -d\  -f1)

-include ${MAKEFILELOCAL}

REPO_DIRS    = $(dir $(BUNDLE_FILES))

-include ${MAKEFILELOCAL}

vpath
vpath %.pfno $(SRCDIR)
vpath %.nfo $(SRCDIR)

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
	$(_E) "Dirs (nightly/release/base):  $(DIR_NIGHTLY) / $(DIR_RELEASE) / $(DIR_BASE)"
	$(_E) "===="

$(OBS_FILE) : $(SRCDIR)/$(CAT_FILENAME)
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
	$(V)-rm -rf $(DIR_NIGHTLY)* $(DIR_RELEASE)* $(SRCDIR)/$(CAT_FILENAME) $(OBS_FILE)

$(DIR_NIGHTLY) $(DIR_RELEASE) : $(BUNDLE_FILES)
	$(_E) "[BUNDLE]"
	$(_E) "[Generating:] $@/."
	$(_V)if [ -e $@ ]; then rm -rf $@; fi
	$(_V)mkdir $@
	$(_V)-for i in $(BUNDLE_FILES); do cp $$i $@; done
bundle: $(DIR_NIGHTLY)

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
$(ZIP_FILENAME): $(TAR_FILENAME) $(DOC_FILENAMES)
	$(_E) "[Generating:] $@"
	$(_V)$(ZIP) $(ZIP_FLAGS) $@ $^
bundle_bzip: $(BZIP_FILENAME)
$(BZIP_FILENAME): $(TAR_FILENAME)
	$(_E) "[Generating:] $@"
	$(_V)$(BZIP) $(BZIP_FLAGS) $<

# Installation process
install: $(TAR_FILENAME) $(INSTALLDIR)
	$(_E) "[INSTALL] to $(INSTALLDIR)"
	$(_V)-cp $(TAR_FILENAME) $(INSTALLDIR)
	$(_E)

release: $(DIR_RELEASE) $(DIR_RELEASE).$(TAR_SUFFIX)
	$(_E) "[RELEASE] $(DIR_RELEASE)"
release-install: release
	$(_E) "[INSTALL] to $(INSTALLDIR)"
	$(_V)-cp $(DIR_RELEASE).$(TAR_SUFFIX) $(INSTALLDIR)
	$(_E)
release_zip: $(DIR_RELEASE).$(TAR_SUFFIX) $(DOC_FILENAMES)
	$(_E) "[Generating:] $(ZIP_FILENAME)"
	$(_V)$(ZIP) $(ZIP_FLAGS) $(ZIP_FILENAME) $^

$(INSTALLDIR):
	$(_E) "$(error Installation dir does not exist. Check your makefile.local)"

remake: clean all

-include $(DEP_FILENAMES)
