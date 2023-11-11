CXX_COMPILER = g++
CXXFLAGS = -fPIC -shared
CXX_STD = -std=c++17
THIRDPARTYCXX = ./src/service/src/3rdParty/pugixml.cpp 
CXXDLL = ./src/service/DLL/sync_service.dll
CXXFILE = ./src/service/src/sync_service.cpp
CXXLFLAGS = -lws2_32

run: clean build finish

build:
	$(CXX_COMPILER) $(CXXFLAGS) $(CXX_STD) $(THIRDPARTYCXX) -o $(CXXDLL) $(CXXFILE) $(CXXLFLAGS)

clean:
	cls

finish:
	@echo Build process is completed.