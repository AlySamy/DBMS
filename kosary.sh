#!/bin/bash 
export LC_ALL=ar_AE.utf8
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

echo "Please enter table name to create: "

check_input	#to invoke this function from helpersFunction.sh
TableName=$returnValue		#returnValue is the value from helpersFunction.sh check_string()



	if [[ -f "$TableName" ]]
	then
		echo "Error: the table already exsit"
	#back to main menue 
	#creattable
	else
		touch $TableName
		row1="ID:"
		row2="int:"
		echo "ID is creat automatic  ==> (PK)"
		i=2
		function AddDataType {
			echo "Enter Column number $i:"
			read culomn
			row1+="$culomn"
			echo "please Choose the datatype:"
			select datatype in "int" "string"
			do
				case $datatype in
					"int" ) row2+="int"; break;;
					"string" ) row2+="string"; break;;
					* ) echo "Invalid choice";
				esac
			done
			
			echo "Insert another column?"
			select check in "yes" "no"
			do
				case $check in
					"yes" )  ((i=i+1)) ;
					row1+=":";row2+=":"; 
					AddDataType ; 
					break ;;
					"no" ) break;;
					* ) echo "error choice";
				esac
			done
		}
		AddDataType
		echo $row1>>$TableName
		echo $row2>>$TableName
		clear
        echo "__________________"
		echo " table created successfully into DB ==> $TableName  :"
		echo "__________________"
		fi
}

# Create_Table()
# {
# 	clear
# 	echo "Enter table name"
# 	check_input
# 	new_table=$returnValue
# 	existed $new_table
# 	if [[ $result = 0 ]];then
# 	table_meta_data=".metaData_"$new_table
# 	touch ./$new_table
# 	touch ./$table_meta_data
# 	numberOfColumns
# 	id_line="id:"
# 	all_lines=$id_line
# 	clear
# 	echo "Hint: First column is id and it is the primary key"
# 	echo "Enter from column number two"
# 	for (( i=1; i<=$resultColNum-1; i++ ))
# 	do
# 	insert_columns
# 	done
# 	  line=${line%?}

# 	echo $all_lines >> ./$table_meta_data
# 	echo $full_column
# 	else
# 	echo "This table already existed"
# 	goTomainMenue
# 	fi
# }

enterColumns()
{
	clear
	full_column=""
	column=0
	echo "Hint: First column is id and it is the primary key"
	echo "Enter column name: "
	check_input
	col_name=$returnValue
	echo "Enter column data type: "
	check_input
	col_type=$returnValue
	if [[ $resultColNum = 1 ]];then
	column="$col_name($col_type)"
	else
	column="$col_name($col_type):"
	fi
	full_column+=$column
}

# Function to insert column names and datatypes
#   all_lines=""
  line=""
insert_columns() {
#   echo "Enter the column name and datatype separated by a space (e.g. column_name datatype):"
#   read -a columns
  
  # Store the column names and datatypes in one line separated by a colon
  check_input
  col_name=$returnValue
  line="$line$col_name:"
#   for column in "${columns[@]}"; do
#     # line=" $line$column:"
# 	echo $column
#   done
  
  all_lines+=$line
#   echo $all_lines
  # Write the line to a file
}

select_datatype()
{
	dataType=""
	select c in int string
	do
		case $c in 
		int)
		dataType=int
		;;
		string)
		dataType=string
		;;
		*)
		echo "Enter valid number"
		;;
		esac

	done
}

numberOfColumns()
{
	resultColNum=0
	# echo "enter number of columns"
	read -p "" number
	if [[ $number =~ ^[0-9]+$ ]]; then
	resultColNum=$number
	else
	echo "please Enter valid number"
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


# Select_From_Table()
# {
	
# }

insert(){
echo -e $blue "enter name of table to insert into"
check_input
tableName=$returnValue	
#read TableName
if [[ -f "$tableName" ]];
	then
		#count number of record
		NF=$(awk -F : 'END{print NR}' $tableName)
		((id = $NF - 1 )) 
		row="$id:"
		#count number of filed
		record=$(awk -F : 'END{print NF}' $tableName)
		for (( i = 2; i <= $record ; i++ )) 
		do
			name=$(awk -F : 'BEGIN {record = '$i'}{if(NR==1){print $record;}}' $tableName)
			datatype=$(awk -F : 'BEGIN {record = '$i'}{if(NR==2){print $record;}}' $tableName)

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
						echo  "the record must is not empty!"
						read val
					done
				done
			fi
			if [[ i -eq $record ]]
			then
				row+="$val"
			else
				row+="$val:"
			fi
		done
		echo $row>>$tableName
		
		echo "The record is inserted to $tableName successfully :)"
		echo "Insert another record?"
		select check in "Yes" "No"
		do
			case $check in
				"Yes" ) clear ; insert  ; clear ; break;;
				"No" )  clear ; break;;
				* ) echo "Erorr choice";
			esac
		done
		
	else
		echo -e $red "There is no table with this name!"
		echo -e $blue
		insert
	fi



}


appear_select_choises()
{
	choice=""
	clear
	arr_of_choices=("All" "By_Row" "By_Column")
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
			*)
			echo "enter valid number "
		esac

	done

}

selectall()
{
 echo -e $grean "Enter table name to present data"
    check_input
    tableName=$returnValue
	sed '3,$!d' $tableName
    echo ""
 #tablemenu
}

Select_By_Row()
{
	echo -e $blue
	getTableName
	if [[ -f "$tableName" ]]; then
	echo "enter id to select its data:"
	numberOfColumns
	id=$resultColNum
	echo -e $grean
	awk -F: -v var="$id" '$1 == var {print $0}' $tableName
	else
	    echo -e $red "table $tableName does not exist"
	fi
}

listtables()
{
        count="$(ls . | wc -l)"
         if [ $count -eq 0 ] ; then
         echo ""
         echo -e $red "you don't have any tables yet "
         else 
         echo ""
         echo -e $grean  "your tables are " 
         echo ""
         ls -p . | grep -v /
         fi
         echo ""
        #tablemenu
}

Drop_table_list()
{
	echo -e $red
	clear
	arr_of_choices=("Drop_Single_table" "Drop_All_Tables")
	select choose in "${arr_of_choices[@]}"
	do
		case $choose in 
			Drop_Single_table)
			Drop_Table
			;;
			Drop_All_Tables)
			Drop_All_Tables
			;;
			*)
			echo "Enter valid number "
		esac

	done
}

Drop_Table()
{
	echo -e $red
	clear
	getTableName
	existed $tableName
	if [[ $result == 0 ]];then
	clear
	echo $result
	echo "not existed";
	goTomainMenue
	else
	clear
	echo "Enter (y) to confirm"
	rm -i -v ./$tableName
	echo -e $grean
	goTomainMenue
	fi
}

Drop_All_Tables()
{ 
	DIRECTORY='./ahmed'
	echo "Do ou realy want to delete ALL TABLES write (y) to confirm ?!"
	# read c1
	# echo "متأكد يا سطا ؟"
	# read c2
	# echo "طب عشان خاطري ؟ "
	# echo "y اكتب بقي "
	read confirm
	if [[ $confirm == 'y' ]];then
	for file in $(find $DIRECTORY -type f); do
    	rm -v $file
	done
	else
	clear
	echo "No Data has been deleted"
	# echo " اقسم بالله (انت اجدع من ابويا)"
	goTomainMenue
	fi
}

Delete_From_Table()
{
	clear
	arr_of_choices=("All" "By_Id" "Delete_By_OtherColumn")
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
			*)
			echo "enter valid number "
		esac

	done
}

deleteAllData() {
	getTableName
  if [[ -f "$tableName" ]]; then
	sed -i '3,$d' $tableName
   echo -e $green "all data deleted successfully from $tableName"
  else
    echo -e $red "table $tableName does not exist"
	#manue
  fi
}

Delete_By_Id()
{
	getTableName
	  if [[ -f "$tableName" ]]; then
	
	echo "enter id to delete its data:"
	numberOfColumns
	id=$resultColNum
	awk -F: -v var="$id" '$1 != var {print $0}' $tableName > tempTable && mv tempTable $tableName
	else
	    echo -e $red "table $tableName does not exist"
	fi
}

Delete_By_OtherColumn()
{
	echo -e $red
	getTableName
	  if [[ -f "$tableName" ]]; then
	read -p "enter value you want to delete by: " column
	
	# echo "enter id to delete its data:"
	# numberOfColumns
	# id=$resultColNum
	echo "Enter (y) to delete all RECORD with value: $column "
	read confirm
	if [[ $confirm == 'y' ]];then

	awk -F: -v var="$column" '{for(i=1; i<=NF; i++) {if($i == var) {next}}} {print $0}' $tableName > tempTable && mv tempTable $tableName
	echo "Recordes Deleted Successfully"
	else
	clear
	echo "No Data Deleted"
	goTomainMenue
	fi
	else
	    echo -e $red "table $tableName does not exist"
	fi
}

Update_Table()
{
	echo -e $blue
	clear
	getTableName
	existed $tableName
	#| select choose in
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
		clear
		awk -F: 'NR==1{for (i=1; i<=NF; i++) printf "%s ", $i; print ""}' $tableName
		echo "Enter the column you want to update on it: "
		read columnName
		if [[ $columnName == "ID" ]];then
			echo "You don't allow to edit on ID"
			Update_Table
		else
		orderOfCol=$(awk -F: -v field_value="$columnName" '$0 ~ field_value {
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
		echo "Old data is: "
		old_data=$(awk -F: -v var="$id" -v var2="$orderOfCol" '$1 == var {print $var2}' $tableName)
		echo -e $red
		echo $old_data
		echo -e $blue
		echo "Enter new value of $columnName"
		read new_Value
		awk -F":" -v field_num=$orderOfCol -v old_value=$old_data -v new_value=$new_Value '{if ($field_num == old_value) {$field_num=new_value}; OFS=":"; print $0}' $tableName > temp_file && mv temp_file $tableName
		echo -e $grean
		echo "Updated Successfuly"
		echo -e $blue
		fi
	else
		echo "Table not exicted"
	fi
}

getTableName()
{
	echo -e $green "Enter the name of the table "	
    check_input
    tableName=$returnValue
}


blue='\033[0;34m'
grean='\033[0;32m'
red='\033[0;31m'

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
			exit
			;;
			*)
			echo "Please enter valid number!"
			;;
		esac
	done
}

chooseArea

