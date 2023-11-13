CXX_COMPILER = g++
CXXFLAGS = -fPIC -shared
CXX_STD = -std=c++17
THIRDPARTYLIB = ./src/service/src/3rdParty/
XMLib = $(THIRDPARTYLIB)XMLib/pugixml.cpp
CXXDLL = ./src/service/DLL/sync_service.dll
CXXFILE = ./src/service/src/sync_service.cpp ./src/service/src/sync_http_client.cpp
CXXLFLAGS = -lws2_32 -lcurl

run: clean build finish

build:
	$(CXX_COMPILER) $(CXXFLAGS) $(CXX_STD) $(XMLib) -o $(CXXDLL) $(CXXFILE) $(CXXLFLAGS)

clean:
	cls

finish:
	@echo Build process is completed.
