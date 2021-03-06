#!/bin/bash
# need a list of subs and a target file to write live subs
function usage(){
  printf "Usage: "
  printf "$0 [subdomains_file] [outfile]\n"
}
if [[ "$#" -ne 2 ]]; then usage; exit ; fi
#vars
alive=0
dead=0
all=0
#empty prev results if needed
> $2
# graphics
echo -e "$(tput setaf 3)
(.............,.,,,,.,,,,,,,*****,,,,,,,,,,*****///////(((((((((((((((
,............,,,,,,,,,,,,,,,,,,***,,,,,,*,**********///(((((/(((((((((
..........,,,,,,,,,,,,,,,,,,,,,,*,,,,,,***************//////(/((((((((
*......,,,,,,,,,,,,,,,,,,.                  ,   .**///(//(////((((((((
*.......,,,,,,,,,,,*        .        .          .  .   .(/////((((((((
,.....,,,,,,,,,,,   .   ..          ..            . ...  ., */((((((((
......,,,,,,,,       .*..,.          *,*. *.   . ... .**,  .. ((((((((
.....,,,,,,,,.      .,., . .(...*.,,,,*,.,./*** ,,*.,,**.,   . (((((((
......,,,,,, .       .*. .., .,. **,,,/,* , (//***,, .*,&*..   (((((((
.....,....,.         ,,*,,...,*,,#/////////*//////*///*#*.*, . (((((((
..........,,       . ,****,,,,**,,*/**/**//////****/((((/*/*   #((((((
.. ........,     .,.,,*/,, ..****. *////*******/***//((((((/...(((((((
.  .........      ,,,,,,//,*/**,*/.*/(/(((((((///**((/(((((/   #((((((
.   ......,.     ./*,,***,,*/////((,/###/##(((((/*/(((((((//.  #((((((
     . .....    ..,*,,,*/,//*((((#((,/###(##(((/(//(((#(((//.  ##((((#
.      .....     ,,/*,*,,*,,,...,,,,****/*******,,*/((((##/.   ####(((
,        ...     ,**/*,.  ..,,         ....   .,*...  ,**(*.  .#((#(((
          **,     ***,.     .     ....,////. .   .     ...%.  *#((///(
        ....,,. .,*/**,.,...,...  ,,*/((((*(* .,.,.,.,,,** ( (////////
         ..,. , .**/*//*,..,..,*/,.**((/(*,((/...* ...,&/#,#/,.,//////
          ,,..***,***/(/,*.****/*,**////(//(//(**,,,**(((/(/ /*///////
        . .,....**,,*****,,*,***,/,,,,,///,,,,/,****((((##(/.,*///****
      .... ,,,*,,**,*******//*,,/,,,***,,,,*(((#*,,*/(((#(/.,**,,*****
    .....,,.*,,,****,*/,***/*,,//*,****,,*,,/(##/,*//*/(/(**/,,,******
 .....,,,,,,.,,,,**/**,,,,,,*,//*******,,****((#/(*/,**//(*/,,,*******
 ....,,,,,,,,,,.,**///,, .*,*/**************//(((//*,***/*.,,,*,******
...,,,,,,,..... .,**///,.,..,,,..            .,*(((/****/.,,,,,,,,****
,...,,,....... ..,**//***/*,*,/*****/*****,**/(/*,((*/*//.,,,,,,,,,***
,,,,,,,,..,,.,,.,.,*,**,**//*//*****//*,**,,**((((((/*/,,,,,,,,,,,,,**
,,,,,......,,,,..,,*/****,*/*/******////////**((//(//,.,,,,,,,,,,,,,,,
,,,,,,,,,,,.,,,,..,**/*,.,**//***********/*(*,,//////,.,,,,,,,,,,,,,,,
,,,,,,*,,,,,,,,,..,,***,,. *///*/,**********//**/////,.,,,,,,,,,,,,,,,
.,,,,,,,,,,,,,,,,..,**,*/,,.,*(///*,****,*,,*//*,/(/,..,,,,,,.,,,,,,,,
,,,,,,,,,.,..,,,,...,,*,/**,.. ..*/((*,.,,*,,,,(///*,. .,,,,...,,.,,.,
..,,,,,*,,....,,,,......,*/,*,.   ....      ,***(,,.....,,,,...,,*..,,
,,,,,.,*,.....,,,,. ...,...,,,,.,...........,,,.*..,... ..,,,....,,...
,,,.,.,,........,,..................,,,,............... ,..,,.....,,..
,,,,............,...xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.,......,,,.
,..,...,....,....,,,x ITS-ALIVE.,.......... ............x.......,. ,.,
..,....,.......,..,,x brought to you by truffle-dog,,...x.........,...
.......,.......,.,,,xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx*,,,,.,...,.,
.......,.......,,,,,.,..,,,,,,,..,,,,,*,,,,.,,,,,,,,,,,, ,,,..,..,.,..
$(tput sgr 0) \n"

# meat
while read line; do
let all++
host $line &>/dev/null
retval=$?
if [[ $retval -ne 0 ]]; then
  printf "$(tput setaf 1)[X] [$line] it's dead $(tput sgr 0)\n"
  let dead++
else
  printf "$(tput setaf 2)$(tput bold)[OK] [$line] IT'S ALIVE! $(tput sgr 0)\n"
  printf "$line\n" >> $2
  let alive++
fi
done < $1
# report
alive_pc=$(bc <<< "scale=2; $alive/$all*100")
dead_pc=$(bc <<< "scale=2; $dead/$all*100")
echo -e "\n$(tput setaf 3)-----------------------$(tput sgr0)"
echo  "$(tput setaf 3)out of $all:$(tput sgr 0)"
echo  "$(tput setaf 3)-----------------------$(tput sgr0)"
echo "$(tput setaf 2)$(tput bold)$alive alive ($alive_pc%) $(tput sgr 0)"
echo "$(tput setaf 1)$dead dead ($dead_pc%)$(tput sgr 0)"
echo  "$(tput setaf 3)-----------------------$(tput sgr0)"
