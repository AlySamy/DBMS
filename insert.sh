
insert() {
    echo -e $grean  "Please enter table name"
	check_input	
	table_name=$returnValue		

 if [[ -f $table_name  ]]
        then
	index=1
	size=0
	row=""
       for tableName in `ls`
        do
            if [ $tableName = $table_name ]; then 
           
	      echo -e $grean "Table Selected successfully" 
              echo  -e  $blue "===================================="
	      echo  -e  $blue "The First Column is primary Key and should be a number"
	      echo  -e  $blue "======================================================="
		array=(`awk -F":" '{if (NR>=3) print $3}' .metaData_$tableName`)
		arr=(`awk -F":" '{print $1}' $tableName`)		
		size=${#array[*]}
		read -p "Enter value of column ${array[0]} : " input
		    if [ -z $input ];  then
                     echo ""
		     echo -e $red  "Primary Key Cann't be Null!!!" 
                     echo ""
                     echo -e $blue"back to menu" 
                     echo ""
                       #  tablemenu

              elif [[ $input =~ [a-zA-Z]+$ ]]; then 
                  echo ""
                  echo -e $RED "Primary Key accept numbers only!!!" 
                  echo ""
                  echo -e $blue"back to menu" 
                  echo ""         
                         # tablemenu
			elif [ ${#arr[*]} -eq 0 ];    then
			inputarray[0]=$input 

               
			while (($index < $size))
			do
			read -p "Enter value of column ${array[index]} : " inputarray[index]
			((index =$index+1))
			done
		else
                    index=0
		while (($index < ${#arr[*]}))
		do
	       if [ $input = ${arr[index]} ];	then
                echo ""
		echo -e $RED "Primary Key must be unique!!!" 
                echo ""
                echo -e $blue"back to menu" 
                echo ""
                           
                        # tablemenu
	         fi
	         ((index =$index+1))
		done

                index=1
                row=${inputarray[0]}
	         inputarray[0]=$input
		while (($index < $size))
		do
		read -p "Enter value of column ${array[index]} : " inputarray[index]
                
                let a=$index+3

               value=$(awk -v patt=$a  -F: '{if (NR == patt) print $4}' .metaData_$tableName)
               
                if [[ -z ${inputarray[index]}  ]]
                then
                 echo ""
                 echo -e $RED "attention this field will be empty field !!!!"
                 echo ""
                 read -p "Do you agree [y or n] ?  : " ans
                 if [[ $ans  == 'y' ]]
                 then
                    ((index =$index+1))
                else   
                   tablemenu
                fi

                elif [[ $value =~ "str" ]] 
                then
               
		if [[ ${inputarray[index]} =~ ^[a-zA-Z] ]]
                then
		((index =$index+1))
                else
                echo -e $red "you should enter string value"
                echo "Please enter your choice"
                return 1
                fi
                elif [[ $value =~ "int" ]] 
                then
                if [[ ${inputarray[index]} =~ [0-9.]+$ ]]
                then
                ((index =$index+1))
                else
                echo -e $red "you should enter number"
                echo "Please enter your choice"
                return 1
                fi
                else
                echo -e $RED "you should enter valid value"
                echo "Please enter your choice"
                return 1
                fi
		done
	fi    
    if [ $? == 0 ]
            then
             {
             index=1
		row=${inputarray[0]}
		while (($index < $size))
		do
		row=$row":"${inputarray[index]}
		((index =$index+1))
		done
              echo " "
                echo $row >> $tableName
                echo -e $grean "Row inserted successfully"
                echo ""
                echo -e $blue "Please enter your choice"
                return 0

             }
              
            fi

		fi	
        done
        else
	echo " "
	echo -e $RED "Table Not exists!!!"
	echo " "
        echo -e $blue "Please enter your choice"
fi
}










