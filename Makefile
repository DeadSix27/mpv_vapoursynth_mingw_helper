GENDEF = gendef
DLLTOOL = dlltool
all:
	@echo Deleting everything except the dlls we need.
	@echo Creating def files.
	$(GENDEF) VapourSynth.dll
	$(GENDEF) VSScript.dll
	@echo Creating mingw libraries.
	$(DLLTOOL) -d VapourSynth.def -l libvapoursynth.a
	$(DLLTOOL) -d VSScript.def -l libvapoursynth-script.a
	@echo Cleaning up.
	
clean:
	rm -f *.def
	@echo Removed all def files
install:
	@echo tbh
uninstall:
	@echo tbd