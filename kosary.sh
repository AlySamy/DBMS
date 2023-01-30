#!/bin/bash

#function to go back to main menue
goTomainMenue() {
echo "please choose input"
choices=("BackToMenue" "Exit")
select result in "${choices[@]}"
do
    case $result in
        "BackToMenue")
            clear ;  chooseArea
            ;;  
        "Exit")
            clear ; exit
            ;;
        *) clear ; echo "Error option " ; goTomainMenue ;;
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
            echo "Wrong value Please enter a value with letters"
		elif [[ $userInput = [[:space:]] ]]; then
	                echo -e $red "wrong value can not contain spaces"
        elif [[ $userInput =~ ^[a-zA-Z]+[0-9]* ]]; then 	#correct db name

            returnValue=$userInput	# to exit the while loop
            flag=1

        else # wrong dbname 
            echo "Wrong value Please enter a value with only letters"
        fi
    done

}

Create_Table()
{
	clear
	echo "enter table name"
	check_input
	new_table=$returnValue
	existed $new_table
	if [[ $result = 0 ]];then
	touch ./$new_table
	numberOfColumns
	echo $result
	else
	echo "This table already existed"
	goTomainMenue
	fi
}

numberOfColumns()
{
	result=0
	# echo "enter number of columns"
	read -p "Enter a number: " number
	if [[ $number =~ ^[0-9]+$ ]]; then
	result=$number
	fi
	# check_input
	# col_num=$returnValue

}

List_Tables()
{
	ls .
}

existed()
{
	result=0
	if [[ ! -f ./$1 ]];then
	result=0
	else
	result=1
	fi
}

Drop_Table()
{
	clear
	echo "enter table name"
	check_input
	table_name=$returnValue
	existed $table_name
	if [[ $result = 0 ]];then
	echo "not existed";
	goTomainMenue
	clear
	else
	echo "enter (y) to confirm"
	rm -i -v ./$table_name
	goTomainMenue
	fi
}

Insert_into_Table()
{
	echo "ahmed"
}

Select_From_Table()
{
	echo "ahmed"
}

Delete_From_Table()
{
	echo "ahmed"
}

Update_Table()
{
	echo "ahmed"
}

chooseArea()
{
	clear
echo "Chooce from "
arrayOfOpt=("Create_Table" "List_Tables" "Drop_Table" "Insert_into_Table" "Select_From_Table" "Delete_From_Table" "Update_Table" "exit")
select choose in "${arrayOfOpt[@]}"
do
	case $choose in 
		Create_Table)
		Create_Table
		;;
		List_Tables)
		List_Tables
		;;
		Drop_Table)
		Drop_Table
		;;
		Insert_into_Table)
		Insert_into_Table
		;;
		Select_From_Table)
		Select_From_Table
		;;
		Delete_From_Table)
		Delete_From_Table
		;;
		Update_Table)
		Update_Table
		;;
		exit)
		exit
		;;
		*)
		echo "Please enter valid number!"
		;;
	esac
done
}

chooseArea

