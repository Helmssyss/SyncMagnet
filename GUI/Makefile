CXX_STD = -std=c++17
CXX = g++
CXXFLAGS = -fPIC -shared
CXXLFLAGS = -lws2_32
CXXDLL = ./src/service/magnet_service.dll
CXXFILE = ./src/service/magnet_service.cpp
THIRDPARTYCXX = ./src/service/third_party/pugixml.cpp 

OUTPUT = $(CXX) $(CXXFLAGS) $(CXX_STD) $(THIRDPARTYCXX) -o $(CXXDLL) $(CXXFILE) $(CXXLFLAGS)

run: clean build finish

build:
	$(OUTPUT)

.PHONY: clean

clean:
	cls

finish:
	@echo Build process is completed.
	python .\main_window.py
# mingw32-make