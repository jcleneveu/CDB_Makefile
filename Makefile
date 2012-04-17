##############################################################################
#               makefile générique fonctionnant avec codeblocks              #
##############################################################################

##############################################################################
# I. LICENSE : GNU GPL                                                       #
##############################################################################

#    Makefile générique fonctionnant avec codeblocks
#    Copyright (C) 2012  Leneveu Jean-Charles

#    This makefile is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.

#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.

#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

##############################################################################
# II. MANUEL D'UTILISATION                                                   #
##############################################################################

# 1. compilation
# pour compiler de façon "traditionnelle" :             make all
# pour compiler comme codeblocks en mode Debug :        make Debug
# pour compiler comme codeblocks en mode Release :      make Release

# 2. nettoyage
# pour tout nettoyer, y compris les zip :               make clean_all
# pour tout nettoyer, sauf les zip générés :            make clean
# pour nettoyer uniquement les fichiers objets :        make clean_obj

# 3. archivage
# pour créer un zip des sources :                       make zipsources
# pour créer un zip des bins :                          make zipbin
# pour créer un zip contenant les bins ET les sources : make zip
# pour créer les 3 zips précédents :                    make allzip

##############################################################################
# III. CONFIGURATION DU MAKEFILE                                             #
##############################################################################

# ATTENTION : ne touchez qu'à cette section du makefile !
# toute autre modification du makefile est à vos risques et périls !

# 1. nom du programme (avec son extension si nécessaire)
EXE=

# 2. compilateur
CC=
# CC=gcc (pour compiler du C)
# CC=g++ (pour compiler du C++)

# 3. extension des sources (langages supportés : c et c++)
EXT=
# EXT=c (pour des fichiers sources C)
# EXT=cpp (pour des fichiers sources C++)

# 4. choix du répertoire de sources (repertoire contenant toutes vos sources .h et .cpp/.c)
# NB : si les fichiers sources sont situés directement à la racine du dossier dans lequel
# se situe le makefile, vous pouvez mettre REP_SRC=.
REP_SRC=
# REP_SRC=src (src est un bon exemple de nom de dossier contenant vos sources...)

# 5. choix du répertoire de ressources (repertoire contenant toutes vos ressources, images, config...)
# NB : vos ressources NE DOIVENT PAS être à la racine du projet mais dans un dossier séparé.
# Vous ne pouvez pas mettre REP_RES=. !
REP_RES=
# REP_RES=res (res est un bon exemple de nom de dossier contenant vos ressources !)

# 6. flags de dépendance de librairies (pour les inclusions de librairies)
DEP_FLAGS=
# pour GTK+ : DEP_FLAGS=`pkg-config gtk+-2.0 --libs` `pkg-config --cflags gtk+-2.0`
# pour allegro : DEP_FLAGS=`allegro-config --libs`

# 7. flags de warnings/error de compilation
OPT_FLAGS=
# bon exemple de flags : OPT_FLAGS=-Winit-self -Wmissing-declarations -Wmissing-include-dirs -Wswitch-default -Wall -O3

##############################################################################
# IV. DEFINITION DES FICHIERS SOURCES (do not edit !)                        #
##############################################################################

SRC=$(wildcard $(REP_SRC)/*/*/*/*/*/*.$(EXT)) $(wildcard $(REP_SRC)/*/*/*/*/*.$(EXT)) $(wildcard $(REP_SRC)/*/*/*/*.$(EXT)) $(wildcard $(REP_SRC)/*/*/*.$(EXT)) $(wildcard $(REP_SRC)/*/*.$(EXT)) $(wildcard $(REP_SRC)/*.$(EXT))
OBJ=$(SRC:.$(EXT)=.o)
CFLAGS=$(DEP_FLAGS) $(OPT_FLAGS)

##############################################################################
# V. OPERATIONS DE COMPILATION (do not edit !)                               #
##############################################################################

all: $(EXE) clean_obj

Debug: $(EXE)
	mkdir bin || true
	mkdir bin/Debug || true
	cp $(EXE) bin/Debug
	cp -R $(REP_RES) bin/Debug

Release: $(EXE) clean_obj
	mkdir bin || true
	mkdir bin/Release || true
	cp $(EXE) bin/Release
	cp -R $(REP_RES) bin/Release

$(EXE): $(OBJ)
	@echo "\n=== linking des objets ===\n"
	$(CC) -o $@ $^ $(CFLAGS)

##############################################################################
# VI. OPERATIONS D'ARCHIVAGE ZIP (do not edit !)                             #
##############################################################################

allzip: zip zipbin zipsources

zip: clean Release
	rm -f $(EXE).zip
	make clean_obj
	zip -r $(EXE).zip bin/Release/$(EXE) bin/Release/$(REP_RES) $(REP_SRC) $(REP_RES) Makefile
	make clean

zipsources: clean
	rm -f $(EXE)_sources.zip
	zip -r $(EXE)_sources.zip $(REP_SRC) $(REP_RES) Makefile

zipbin: clean all
	rm -f $(EXE)_bin.zip
	zip -r $(EXE)_bin.zip $(EXE) $(REP_RES)
	make clean

##############################################################################
# VII. OPERATIONS DE NETTOYAGE (do not edit !)                               #
##############################################################################

cleanDebug: clean_all

cleanRelease: clean_all

clean_all: clean_zip clean

clean: clean_obj clean_cdb
	rm -f $(EXE)

clean_cdb:
	rm -f $(EXE).layout $(EXE).depend
	find . -name "*.bak" -exec rm -f {} \;
	find . -name "*.temp" -exec rm -f {} \;
	rm -Rf bin

clean_zip:
	rm -f $(EXE).zip
	rm -f $(EXE)_bin.zip
	rm -f $(EXE)_sources.zip
	
clean_obj:
	@echo "\n=== Clean up du projet ===\n"
	rm -f $(OBJ)
	@echo "done.\n"