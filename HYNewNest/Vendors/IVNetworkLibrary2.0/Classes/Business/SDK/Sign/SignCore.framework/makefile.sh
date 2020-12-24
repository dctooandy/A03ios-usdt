g++ -fPIC -c -std=c++0x ./source/JavaFormatConvert.cpp ./source/MD5.cpp ./source/StringFunctions.cpp ./source/SignIdentifier.cpp
g++ -shared -o SignIdentifier_Linux.so SignIdentifier.o JavaFormatConvert.o MD5.o StringFunctions.o
