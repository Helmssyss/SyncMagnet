CXX_COMPILER = g++
CXX_STD = -std=c++17
CXXFILE = ./src/sync_update.cpp 
CXXLFLAGS = -lcurl
OUTPUT = ./update.exe ./src/sync_update_main.cpp

run: clean build finished

build:
	$(CXX_COMPILER) $(CXX_STD) $(CXXFILE) -o $(OUTPUT) $(CXXLFLAGS)

clean:
	cls

finished:
	@echo 'update' Build Process Is Completed