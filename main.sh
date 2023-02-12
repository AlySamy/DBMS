#!/bin/bash 

 mainMenue(){
    PS3=">> "
    clear
    if [[ ! -d $DB ]];
		then mkdir -p databases  #create databases folder if not exists			
    fi

echo -e $blue
choice=("CreateDataBase" "ListDatabase" "ConnectToDB" "DropDB" "Exit")

select result in "${choice[@]}"
do
    case $result in
        "CreateDataBase")
           clear ;  createDatabase;  goTomainMenue
            ;;
        "ListDatabase")
           clear ; listAllDatabase;  goTomainMenue
            ;;
        "ConnectToDB")
            clear ; conactDB; goTomainMenue
            ;;
        "DropDB")
            clear ;  DropDatabase;  goTomainMenue
            ;;  
        "Exit")
            echo "thanks :) " ; exit
            ;;
        *) clear ; echo -e $red "Erorr plese agian enter choice " ; . main.sh ;;
    esac
done
}



########################################################creatdatabase##########################################

# function create db 
function createDatabase {
	
	echo -e $grean  "Please enter database name"
	check_input	

	DBName=$returnValue

	if [[ ! -d $DB/$DBName ]];
		then	mkdir $DB/$DBName;
				if [[ $? -eq 0 ]]; then
					echo -e $grean $DB" Database created successfully" ;
				else	
					echo -e $red "Error Creating  Database" ;
				fi
	else	
		echo -e $red "Database already exists";
	fi
}

#function to list all data base
listAllDatabase() {

count="$(ls $DB/ | wc -l)"
if [ $count -eq 0 ] ; then
   echo -e $red "You don't have any database yet "
else 
   echo -e $grean  "your databases are : "
   echo "" 
     ls $DB/
fi
echo ""

}


DropDatabase() {

echo -e $red "Enter Database name to drop"
check_input
DbName=$returnValue	

if [[ -d "$DB/$DbName" ]]
then

    echo "enter (y) to confirm"
	rm -r -i $DB/$DbName
	if [[ ! -d "$DB/$DbName" ]]
	then
    	echo -e $grean  "Deleted susscesfuly "
	fi

else
	echo -e $red "Database not found !";  goTomainMenue 

    fi
}


conactDB() {
    clear
    listAllDatabase
echo -e $grean "Please enter DB name to connect"
check_input
DBName=$returnValue	
if [[ -d "$DB/$DBName" ]]
then
   cd $DB/$DBName
   clear 
   echo -e $grean "Database $DBName was Successfully connected"
   . "../.././tables.sh"
else
echo -e $red "can not connect to database !";  goTomainMenue 
fi
}


goTomainMenue() {
echo -e $grean "please choose input"
echo -e $blue
choices=("BackToMenue" "Exit")
select result in "${choices[@]}"
do
    case $result in
        "BackToMenue")
            clear ;  mainMenue
            ;;  
        "Exit")
            clear ; exit
            ;;
        *) clear ; echo -e $red "Error option " ; goTomainMenue ;;
    esac
done

}

#check_input
 check_input(){

    returnValue=0	#initialize db name 

    flag=0	#to exit the while loop


    while [ $flag == 0 ]
    do
    
        read userInput
        if [[ $userInput = "" ]]; then
            echo -e $red "Wrong value Please enter a value with only letters"

             elif [[ $userInput = *[[:space:]]* ]]; then
	                echo -e $red "wrong value can not contain spaces"

        elif [[ $userInput =~ ^[a-zA-Z]+[0-9]* ]]; then 	

            returnValue=$userInput
            flag=1

        else 
            echo -e $red "Wrong value Please enter a value with only letters"
        fi
    done

}
#######################main#########################
DB="databases";
blue='\033[0;34m'
grean='\033[0;32m'
red='\033[0;31m'
mainMenue







