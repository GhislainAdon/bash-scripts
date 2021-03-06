#!/bin/bash
# Obtenir la date de création de fichiers ou dossiers sur un système de fichiers EXT4.
# Licence CC BY-NC-SA 4.0 ( https://creativecommons.org/licenses/by-nc-sa/4.0/ )
# Auteur : Mickaël BONNARD ( https://www.mickaelbonnard.fr )

IFS='
'
# On se place dans le répertoire donné en paramètre.

cd $1

echo -e "Voici les dates de création des fichiers et dossiers présents dans $1 :\n" 

# Le classement se fait par ordre croissant.
# Pour n'afficher que les dossiers, utiliser la commande "for fichiers in $(ls -d */)".
# Pour n'afficher que les fichiers, utiliser la commande "for fichiers in $(find -type f | xargs ls -1rt)".

for fichiers in $(ls -1rt)

do

# On recherche l'inode du fichier ou dossier à l'aide de la commande stat ( les 2 commandes fonctionnent ).

inode=$(stat -c %i "${fichiers}")

#inode=$(ls -i "${fichiers}" | awk '{print $1}')

# On recherche sur quelle partition est située le fichier ou dossier ( les 2 commandes fonctionnent ).

#systeme_fichier=$(df "${fichiers}" | tail -1 | awk '{print $1}')

partition=$(df "${fichiers}" | awk 'NR==2 {print $1}')

# Avec l'inode et la partition, on extrait la date de création du fichier ou dossier.

date_creation=$(debugfs -R 'stat <'"${inode}"'>' "${partition}" 2>/dev/null |  grep 'crtime' | awk -F '--' {'print $2'} | awk {'print $1" "$3" "$2" "$5" "$4'})

# On récupère le nom du fichier ou dossier sans le chemin complet.

noms_fichiers=`basename "$fichiers"`

# On affiche le nom du fichier ou dossier avec sa date de création.

echo "${noms_fichiers}" : "${date_creation}"

done
