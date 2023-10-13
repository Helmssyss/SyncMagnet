CXX_STD = -std=c++17
CXX_COMPILER = g++
CXXFLAGS = -fPIC -shared
CXXLFLAGS = -lws2_32
CXXDLL = ./src/service/magnet_service.dll
CXXFILE = ./src/service/magnet_service.cpp
THIRDPARTYCXX = ./src/service/third_party/pugixml.cpp 

run: clean build finish

build:
	$(CXX_COMPILER) $(CXXFLAGS) $(CXX_STD) $(THIRDPARTYCXX) -o $(CXXDLL) $(CXXFILE) $(CXXLFLAGS)

clean:
	cls

finish:
	@echo Build process is completed.
