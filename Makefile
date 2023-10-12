CXX = g++
CXX_STD = -std=c++17
CXXFLAGS = -I./src/Public
LDFLAGS = -lws2_32
SRCS = ./src/Private/console.cpp ./src/Private/server.cpp ./main.cpp
OUTPUT = ./SyncMagnetCLI.exe

run: clean build finished

build:
	$(CXX) $(CXX_STD) $(SRCS) -o $(OUTPUT) $(CXXFLAGS) $(LDFLAGS)

clean:
	cls

finished:
	@echo Build Process Is Completed