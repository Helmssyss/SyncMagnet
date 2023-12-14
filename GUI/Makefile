CXX_COMPILER = g++
CXXFLAGS = -fPIC -shared
CXX_STD = -std=c++17
CXXDLL = ./sync_service.dll
CXXFILE = ./src/service/src/sync_service.cpp
CXXLFLAGS = -lws2_32 -lpugixml

run: clean build finish

build:
	$(CXX_COMPILER) $(CXXFLAGS) $(CXX_STD) -o $(CXXDLL) $(CXXFILE) $(CXXLFLAGS)

clean:
	cls

finish:
	@echo Build process is completed.
