#!/bin/bash 
#function to go back to main menue
Back_table_menu() {
	echo "please choose input"
	choices=("BackToMenu" "Exit")
	select result in "${choices[@]}"
	do
		case $result in
			"BackToMenu")
				clear ;  chooseArea
				;;  
			"Exit")
				cd ../../
				clear ; . "./main.sh"
				;;
			*) clear ; echo "Error option " ; Back_table_menu ;;
		esac
	done
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

numberOfColumns()
{
	resultColNum=0
	# echo "enter number of columns"
	read -p "" number
	if [[ $number =~ ^[0-9]+$ && $number != "" ]]; then
	resultColNum=$number
	else
	echo "please Enter valid number"
	numberOfColumns
	fi
	# check_input
	# col_num=$returnValue
}


check_input(){

    returnValue=0	 

    flag=0
    while [ $flag == 0 ]
    do
    
        read userInput
        if [[ $userInput = "" ]]; then
            echo "Wrong value Please enter a value with letters"
		elif [[ $userInput = [[:space:]] ]]; then
	                echo -e $red "wrong value can not contain spaces"
        elif [[ $userInput =~ ^[a-zA-Z]+[0-9]* ]]; then 	

            returnValue=$userInput
            flag=1

        else 
            echo "Wrong value Please enter a value with only letters"
        fi
    done

}

Create_Table()
{
	echo "Please enter table name to be created: "
	check_input	
	TableName=$returnValue
	if [[ -f "$TableName" ]]
	then
		echo "Error: the table already exsit"
	Back_table_menu
	else
		touch $TableName
		row1="ID:"
		row2="int:"
		echo "ID is created automaticly  ==> (PK)"
		i=2
		function AddMetaData {
			echo -e $green "Enter Column number $i's name:"
			read column
			row1+="$column"
			echo "please Choose the datatype:"
			echo -e $blue
			select datatype in "int" "string"
			do
				case $datatype in
					"int" ) row2+="int"; break;;
					"string" ) row2+="string"; break;;
					* ) echo -e $red "Invalid choice";
				esac
			done
			echo -e $blue "Insert another column?"
			select check in "yes" "no"
			do
				case $check in
					"yes" )  ((i=i+1)) ;
					row1+=":";row2+=":"; 
					AddMetaData; 
					break ;;
					"no" ) break;;
					* ) echo -e $red "error choice";
				esac
			done
		}
		AddMetaData
		echo $row1>>$TableName
		echo $row2>>$TableName
		clear
        echo -e $red "ــــــــــــــــــــــــــــــــــــــــــــــــــــــــــــــ"
		echo -e $green "Table created successfully into DB ==> $TableName  :"
        echo -e $red "ــــــــــــــــــــــــــــــــــــــــــــــــــــــــــــــ"
		echo -e $blue
		Back_table_menu
		fi
}


insert(){
	clear
	echo -e $blue
	listtables_for_fuctiont
	if [[ $caheckTables != 0 ]];then
		echo -e $green "Enter name of table to insert into:"
		check_input
		tableName=$returnValue
		if [[ -f "$tableName" ]];
			then
			NR=$(awk -F: 'END{print NR}' $tableName)
			((id = $NR - 1 ))
			row="$id:"
			field=$(awk -F : 'END{print NF}' $tableName)
			for (( i = 2; i <= $field ; i++ )) 
			do
				name=$(awk -F : 'BEGIN {field = '$i'}{if(NR==1){print $field;}}' $tableName)
				datatype=$(awk -F : 'BEGIN {field = '$i'}{if(NR==2){print $field;}}' $tableName)

				echo "Insert values into column ($name):"
				read val
				if [[ $datatype == "int" ]]
				then
					while ! [[ $val =~ ^[0-9]*$ ]] 
					do
						echo  "Error: you enterd a string, please enter an integer !"
						read val
						while  [[ $val == "" ]] 
						do
							echo  "The record mustn't be empty!"
							read val
						done
					done
				fi
				if [[ i -eq $field ]]
				then
					row+="$val"
				else
					row+="$val:"
				fi
			done
			echo $row>>$tableName
			
			echo -e $green "The record is inserted to $tableName successfully :)"
			echo -e $blue "Insert another record?"
			select check in "Yes" "No"
			do
				case $check in
					"Yes" ) clear ; insert ;;
					"No" )  clear ; Back_table_menu;;
					* ) echo "Erorr choice";
				esac
			done
		
		else
			echo -e $red "There is no table with this name!"
			echo -e $blue
			insert
		fi
	else
		echo -e $red "No tables founded"
		echo -e $blue
		Back_table_menu
	fi
}


listtables()
{
	clear
	count="$(ls . | wc -l)"
		if [ $count -eq 0 ] ; then
			echo -e $red "You don't have any tables yet."
		else 
			echo -e $green "Your tables are:" 
			echo ""
			ls -p . | grep -v / | grep -v .sh$
		fi
		echo -e $blue ""
	Back_table_menu
}

appear_select_choises()
{
	choice=""
	clear
	arr_of_choices=("All" "By_Row" "By_Column" "Exit")
	select choose in "${arr_of_choices[@]}"
	do
		case $choose in 
			All)
			selectall
			;;
			By_Row)
			Select_By_Row
			;;
			By_Column)
			Select_By_Column
			;;
			Exit)
			chooseArea
			;;
			*)
			echo -e $red "enter valid number "
			echo -e $blue
		esac
	done
}

Select_By_Column()
{
	clear
	echo -e $blue
	listtables_for_fuctiont
	getTableName
	existed $tableName
	if [[ $result != "0" ]];then
		columns=$(awk -F: 'NR==1{for (i=1; i<=NF; i++) printf "%s ", $i; print ""}' $tableName)
		echo ""
		echo -e $blue $columns
		array_of_columns=($columns)
		echo ""
		echo "Enter the column you want to select: "
		check_input
		if [[ " ${array_of_columns[@]} " =~ " $returnValue " ]];then
			orderOfCol=$(awk -F: -v field_value="$returnValue" '$0 ~ field_value {
			for (i = 1; i <= NF; i++) {
			if ($i == field_value) {
				print i
				break
					}
				}
			}' $tableName)
			clear
			echo -e $green "Data are:"
			awk -F: -v order="$orderOfCol" 'NR>=3 {print $order}' $tableName
			echo -e $blue
			Back_table_menu
		else
			clear
			echo -e $red "No column with that name: $returnValue"
			echo -e $blue
			Back_table_menu
		fi
	else
		echo -e $red "No table with that name: $tableName"
		echo -e $blue
		Back_table_menu
	fi

}

selectall()
{
	clear
	listtables_for_fuctiont
 	echo -e $green "Enter table name to present data"
    check_input
    tableName=$returnValue
	# sed '1,$!d' $tableName
	sed -n 'p' $tableName
    echo ""
	Back_table_menu
}

Select_By_Row()
{
	clear
	listtables_for_fuctiont
	echo -e $blue
	getTableName
	if [[ -f "$tableName" ]]; then
	echo "Enter id to select its data:"
	numberOfColumns
	id=$resultColNum
	IDs=$(awk -F: 'NR >= 3 {printf "%s ", $1} END {print ""}' $tableName)
	array_of_IDs=($IDs)
	if [[ $id != 0 && " ${array_of_IDs[@]} " =~ " $id " ]]
	then
		echo -e $green
		awk -F: -v var="$id" '$1 == var {print $0}' $tableName
		echo ""
		Back_table_menu
	else
		echo -e $red "Your id: $id dosen't exict"
		echo -e $blue
		Back_table_menu
	fi
	else
	    echo -e $red "table $tableName does not exist"
		appear_select_choises
	fi
}



listtables_for_fuctiont()
{
	clear
        count="$(ls . | wc -l)"
		caheckTables=0
         if [ $count -eq 0 ] ; then
         echo -e $red "You don't have any tables yet."
         else
         echo -e $blue "Your tables are:" 
         ls -p . | grep -v / | grep -v .sh$
		 caheckTables=1
         fi
         echo -e $blue ""
}

Drop_table_list()
{
	
	echo -e $red
	clear
	arr_of_choices=("Drop_Single_table" "Drop_All_Tables" "Exit")
	select choose in "${arr_of_choices[@]}"
	do
		case $choose in 
			Drop_Single_table)
			Drop_Table
			;;
			Drop_All_Tables)
			Drop_All_Tables
			;;
			Exit)
			chooseArea
			;;
			*)
			echo "Enter valid number "
		esac

	done
}

Drop_Table()
{
	echo -e $blue "Your tables are : "
	listtables_for_fuctiont
	echo -e $red
	getTableName
	existed $tableName
	if [[ $result == 0 ]];then
	clear
	echo -e $red "Not existed";
	Back_table_menu
	else
	clear
	echo "Enter (y) to confirm"
	rm -i -v ./$tableName
	echo -e $green
	clear
	echo -e $green "Table deleted Successfuly."
	echo -e $blue
	Back_table_menu
	fi
}

Drop_All_Tables()
{ 
	echo -e $blue "Your tables are : "
	listtables_for_fuctiont
	# DIRECTORY= "./"
	echo "Do you realy want to delete ALL TABLES write (y) to confirm ?!"
	# read c1
	# echo "متأكد يا سطا ؟"
	# read c2
	# echo "طب عشان خاطري ؟ "
	# echo "y اكتب بقي "
	read confirm
	if [[ $confirm == 'y' ]];then
	for file in $(find . -type f); do
    	rm -v $file
	done
		Back_table_menu
	else
	clear
	echo -e $green "No Data has been deleted"
	# echo " اقسم بالله (انت اجدع من ابويا)"
	echo -e $blue
	Back_table_menu
	fi
}

Delete_From_Table()
{
	clear
	arr_of_choices=("All" "By_Id" "Delete_By_OtherColumn" "Exit")
	select choose in "${arr_of_choices[@]}"
	do
		case $choose in 
			All)
			deleteAllData
			;;
			By_Id)
			Delete_By_Id
			;;
			Delete_By_OtherColumn)
			Delete_By_OtherColumn
			;;
			Exit)
			clear; chooseArea
			;;
			*)
			echo "enter valid number "
		esac

	done
}

deleteAllData() {
	clear
	listtables_for_fuctiont
	getTableName
  if [[ -f "$tableName" ]]; then
	sed -i '3,$d' $tableName
   echo -e $green "all data deleted successfully from $tableName"
   Back_table_menu
  else
    echo -e $red "Table '$tableName' does not exist"
   Back_table_menu
  fi
}

Delete_By_Id()
{
	clear
	listtables_for_fuctiont
	getTableName
	if [[ -f "$tableName" ]]; then
		echo "Enter id to delete its data:"
		numberOfColumns
		id=$resultColNum
		IDs=$(awk -F: 'NR >= 3 {printf "%s ", $1} END {print ""}' $tableName)
		array_of_IDs=($IDs)
		if [[ $id != "0" && " ${array_of_IDs[@]} " =~ " $id " ]];then
			awk -F: -v var="$id" '$1 != var {print $0}' $tableName > tempTable && mv tempTable $tableName
			clear
			echo -e $green "Id : $id's data deleted Successfully."
			echo -e $blue ""
			Back_table_menu
		else
			echo -e $red "No id with: $id"
			echo -e $blue
			Back_table_menu
		fi
	else
	    echo -e $red "Table $tableName does not exist"
		Back_table_menu
	fi
}

Delete_By_OtherColumn()
{
	PS3=">>"
	clear
	listtables_for_fuctiont
	echo -e $red
	getTableName
	if [[ -f "$tableName" && $tableName != "" ]]; then
		read -p "Enter value you want to delete by: " column
		echo "Enter (y) to delete all RECORDS with value: $column "
		read confirm
		if [[ $confirm == 'y' ]];then
		awk -F: -v var="$column" '{for(i=1; i<=NF; i++) {if($i == var) {next}}} {print $0}' $tableName > tempTable && mv tempTable $tableName
		clear
		echo -e $green "Recordes Deleted Successfully"
		Back_table_menu
		else
		clear
		echo -e $green "No Data Deleted"
		Back_table_menu
		fi
	else
		clear
	    echo -e $red "Table $tableName does not exist"
		echo -e $blue ""
		Back_table_menu
	fi
}

Update_Table()
{
	clear
	echo -e $blue
	listtables_for_fuctiont
	getTableName
	existed $tableName
	if [[ $result != 0 ]];then
		# awk -F: 'NR==1{for (i=1; i<=NF; i++) printf "%s ", $i; print ""}' $tableName  
		# awk -F ":" 'NR==1 {for (i=1; i<=NF; i++) {print $i}}' $tableName 
		# result=$(awk -F ":" 'NR==1 {for (i=1; i<=NF; i++) {print $i}}' $tableName)
		# array=($result)

		# select choose in "${array[@]}"
		# do
		# 	for element in "${array[@]}"
		# 	do
		# 		case $element in 
		# 			*) echo "Element: $element";;
		# 		esac
		# 	done

		# 	# case $choose in
		# 	# 	name)
		# 	# 	echo "Ahmed"
		# 	# 	;;
		# 	# 	*)
		# 	# 	echo "enter valid number "
		# 	# esac

		# done
		# clear
		echo ""
		echo -e $blue "Columns are:"
		columns=$(awk -F: 'NR==1{for (i=1; i<=NF; i++) printf "%s ", $i; print ""}' $tableName)
		echo $columns
		array_of_columns=($columns)
		echo ""
		echo "Enter the column you want to update: "
		check_input
		if [[ $returnValue == "ID" ]];then
			echo -e $red "You don't allow to edit on ID"
			echo -e $blue
			Back_table_menu
		elif [[ " ${array_of_columns[@]} " =~ " $returnValue " ]];then
			orderOfCol=$(awk -F: -v field_value="$returnValue" '$0 ~ field_value {
			for (i = 1; i <= NF; i++) {
			if ($i == field_value) {
				print i
				break
					}
				}
			}' $tableName)
			echo "Enter ID to update its data: "
			numberOfColumns
			id=$resultColNum
			IDs=$(awk -F: 'NR >= 3 {printf "%s ", $1} END {print ""}' $tableName)
			array_of_IDs=($IDs)
			if [[ $id != "0" && " ${array_of_IDs[@]} " =~ " $id " ]];then
				echo "Old data is: "
				old_data=$(awk -F: -v var="$id" -v var2="$orderOfCol" '$1 == var {print $var2}' $tableName)
				echo -e $red
				echo $old_data
				echo -e $blue
				echo "Enter new value of $returnValue"
				read new_Value
				awk -F":" -v field_num=$orderOfCol -v old_value=$old_data -v new_value=$new_Value '{if ($field_num == old_value) {$field_num=new_value}; OFS=":"; print $0}' $tableName > temp_file && mv temp_file $tableName
				clear
				echo -e $green
				echo "Updated Successfuly"
				echo -e $blue
				Back_table_menu
			else
				echo -e $red "No ID with value $id"
				echo -e $blue
				Back_table_menu
			fi
		else
			echo -e $red "This value: $returnValue does not match any column name!"
			echo -e $blue ""
			Back_table_menu
		fi
	else
		clear
		echo -e $red "Table '$tableName' does not exicted"
		Back_table_menu
	fi
}


getTableName()
{
	echo -e $green "Enter the name of the table "	
    check_input
    tableName=$returnValue
}


blue='\033[0;34m'
green='\033[0;32m'
red='\033[0;31m'

chooseArea()
{
	PS3=">>"
	clear
	echo -e $blue
	echo "Chooce from "
	arrayOfOpt=("Create_Table" "List_Tables" "Drop_Table" "Insert_into_Table" "Select_From_Table" "Delete_From_Table" "Update_Table" "exit")
	select choose in "${arrayOfOpt[@]}"
	do
		case $choose in 
			Create_Table)
			Create_Table
			;;
			List_Tables)
			listtables
			;;
			Drop_Table)
			Drop_table_list
			;;
			Insert_into_Table)
			insert
			;;
			Select_From_Table)
			appear_select_choises
			;;
			Delete_From_Table)
			Delete_From_Table
			;;
			Update_Table)
			Update_Table
			;;
			exit)
			clear 
			cd ../../
			. "./main.sh"
			;;
			*)
			echo "Please enter valid number!"
			;;
		esac
	done
}

chooseArea

