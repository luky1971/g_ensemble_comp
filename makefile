CC=gcc
CXX=g++
GROMACS=/usr/local/gromacs
VGRO=5
SVM=../libsvm-3.20
INSTALL=/usr/local/bin

ifeq ($(VGRO),5)
INCGRO=-I$(GROMACS)/include/ -I$(GROMACS)/include/gromacs/utility -I$(GROMACS)/include/gromacs/fileio -I$(GROMACS)/include/gromacs/commandline -I$(GROMACS)/include/gromacs/legacyheaders
LINKGRO=-L$(GROMACS)/lib/i386-linux-gnu
LIBGRO=-lgromacs
DEFV5=-D GRO_V5
else
INCGRO=-I$(GROMACS)/include/gromacs
LINKGRO=-L$(GROMACS)/lib
LIBGRO=-lgmx
DEFV5=
endif

.PHONY: install clean 

etanalys: etanalys.o svmanalys.o
	$(CXX) -o etanalys etanalys.o svmanalys.o $(SVM)/svm.o $(LINKGRO) $(LIBGRO)

install: etanalys
	install etanalys $(INSTALL)

etanalys.o: src/etanalys.c src/svmanalys.h
	$(CC) -c src/etanalys.c $(INCGRO) -I$(SVM) $(DEFV5)

svmanalys.o: src/svmanalys.c src/svmanalys.h
	$(CC) -c src/svmanalys.c $(INCGRO) -I$(SVM) $(DEFV5)

clean:
	rm -f etanalys.o svmanalys.o etanalys