PREFIX=output
GENDEF=gendef
DLLTOOL=dlltool
SED_CMD=sed
WGET_CMD=wget -q --show-progress
INCLUDE_FILES_URL = "https://github.com/DeadSix27/mpv_vapoursynth_python_mingw/releases/download/R35/vapoursynth_R35_mingw_includes.tar.gz"
INCLUDE_FILES_NAME = "vapoursynth_R35_includes.tar.gz"
ARCHTYPE=64
RELEASE_FILE_URL = "https://github.com/DeadSix27/mpv_vapoursynth_python_mingw/releases/download/R35/VapourSynth$(ARCHTYPE)-Portable-R35.tar.gz"
RELEASE_FILE_NAME = "VapourSynth$(ARCHTYPE)-Portable-R35.tar.gz"
TAR_CMD = tar
PYTHON_CMD = python

all:
	@echo Downloading include files..
	$(WGET_CMD) $(INCLUDE_FILES_URL) -O $(INCLUDE_FILES_NAME)
	@echo Extracting..
	$(TAR_CMD) xfz "$(INCLUDE_FILES_NAME)"
	@echo Downloading binaries..
	$(WGET_CMD) $(RELEASE_FILE_URL) -O $(RELEASE_FILE_NAME)
	mkdir _vstemp
	$(TAR_CMD) xfz "$(RELEASE_FILE_NAME)" -C _vstemp
	mv -v _vstemp/VapourSynth.dll .
	mv -v _vstemp/VSScript.dll .
	@echo Deleting everything except the dlls we need.
	rm -dr _vstemp
	@echo Creating def files.
	$(GENDEF) VapourSynth.dll
	$(GENDEF) VSScript.dll
	@echo Creating mingw libraries.
	$(DLLTOOL) -d VapourSynth.def -l libvapoursynth.a
	$(DLLTOOL) -d VSScript.def -l libvapoursynth-script.a
	
	@echo Creating PKG-Config files
	$(WGET_CMD) https://raw.githubusercontent.com/DeadSix27/mpv_vapoursynth_python_mingw/master/vapoursynth-script.pc
	$(WGET_CMD) https://raw.githubusercontent.com/DeadSix27/mpv_vapoursynth_python_mingw/master/vapoursynth.pc
	$(PYTHON_CMD) create_pc.py "vapoursynth-script.pc" $(PREFIX)
	$(PYTHON_CMD) create_pc.py "vapoursynth.pc" $(PREFIX)
	@echo Cleaning up..
	rm *.tar.gz
	
clean:
	rm -f *.def *.pc *.a *.dll *.tar.gz
	rm -drf _vstemp include vapoursynth
	@echo Removed all def files
install:
	@echo Installing into $(PREFIX)
	mkdir -p $(PREFIX)
	mkdir -p $(PREFIX)/lib/pkgconfig/
	cp -rv ./libvapoursynth.a $(PREFIX)/lib/libvapoursynth.a
	cp -rv ./vapoursynth.pc $(PREFIX)/lib/pkgconfig/vapoursynth.pc
	cp -rv ./vapoursynth.pc $(PREFIX)/lib/libvapoursynth-script.a
	cp -rv ./vapoursynth-script.pc $(PREFIX)/lib/pkgconfig/vapoursynth-script.pc
	mkdir -p  $(PREFIX)/include/vapoursynth
	cp -rv ./vapoursynth  $(PREFIX)/include/
uninstall:
	rm -fr $(PREFIX)/lib/pkgconfig/vapoursynth.pc $(PREFIX)/lib/pkgconfig/vapoursynth-script.pc
	rm -fr $(PREFIX)/lib/libvapoursynth-script.a $(PREFIX)/lib/libvapoursynth.a
	rm -fr $(PREFIX)/include/vapoursynth
