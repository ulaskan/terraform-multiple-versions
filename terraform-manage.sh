#! /usr/bin/env bash
# This script installs and/or activates an available version of terraform on Mac

PACKAGE="terraform"

function Install_New_Version {
    echo -e "\033[0;36m\nThese are the available Terraform versions: "
    VERSIONS+=( $(curl -s https://releases.hashicorp.com/terraform/ | grep "href=\"/terraform" | cut -d "/" -f3 | grep -v "-") )

    for ((j=0; j<${#VERSIONS[@]}; j++));
    do
        printf "\033[0;32m${VERSIONS[j]}\t\t"
    done

    printf "\033[0;36m\n\n Please type in the version you want to install: \033[0m"
    read VERSION_TO_INSTALL

    ### Download and Install if already not installed:
    if [ ! -d /usr/local/Cellar/$PACKAGE/$VERSION_TO_INSTALL ];
    then
        wget https://releases.hashicorp.com/terraform/$VERSION_TO_INSTALL/terraform_"$VERSION_TO_INSTALL"_darwin_amd64.zip -P /tmp/ --no-check-certificate
        if [ $? == 0 ];
        then
            cd /tmp
            unzip terraform_"$VERSION_TO_INSTALL"_darwin_amd64.zip
            mkdir -p /usr/local/Cellar/$PACKAGE/$VERSION_TO_INSTALL/
            cp /tmp/$PACKAGE /usr/local/Cellar/$PACKAGE/$VERSION_TO_INSTALL/
            rm -rf /tmp/$PACKAGE*
            echo -e "\033[0;36m\n\n Terraform version $VERSION_TO_INSTALL is now installed and ready to use. \n\033[0m"
         else
            echo -e "\033[0;31m\n Terraform version $VERSION_TO_INSTALL could not be installed! Please check again ... \n\033[0m"
            rm -rf /tmp/$PACKAGE*
            exit
         fi
    else
        echo -e "\033[0;31m Terraform version $VERSION_TO_INSTALL already exists! Exiting ... \n\033[0m"
        exit
    fi
}


function Uninstall_Version {
    echo -e "\033[1;31m\n Please type in the version you want to UNINSTALL!: \033[0m"
    Get_Version
    if [ -d /usr/local/Cellar/$PACKAGE/$VERSION_SELECTED ];
    then
        echo -e "\nUninstalled $VERSION_SELECTED ...\n"
        rm -rf /usr/local/Cellar/$PACKAGE/$VERSION_SELECTED
    else
        echo "$VERSION_SELECTED does not exist. Exiting ..."
    fi
    exit
}


 function Get_Version {
    TERRAFORM_LIST=( $(ls -1 /usr/local/Cellar/$PACKAGE) )
    j=1
    for i in "${TERRAFORM_LIST[@]}"
    do
        printf " $j. \033[0;32m$i \n\033[0m"
        j=$(( $j + 1 ))
    done
    echo
    read -p ">>> " VERSION_SELECTED

    while [ ! -d /usr/local/Cellar/$PACKAGE/$VERSION_SELECTED ];
    do
        printf "\033[1;36m Invalid choice! Please type a correct package version: \033[0m"
        read VERSION_SELECTED
    done
}


function Switch_Version {
    echo -e "\033[1;36m\nPlease type one of the following available Packages to switch to: \033[0m"
    Get_Version
    ln -sfn /usr/local/Cellar/$PACKAGE/$VERSION_SELECTED/$PACKAGE /usr/local/bin/$PACKAGE
    echo -e "\n Now using $PACKAGE $VERSION_SELECTED ... \n"
}


function Exit {
    exit
}


function Main_Function {
    FUNCTIONS_LIST=( $(grep "^function" $0 | awk '{print $2;}' ) )    # Load function names in this script to the array
    unset 'FUNCTIONS_LIST[${#arr[@]}-1]'                              # Remove this function item from the functions array
    j=1
    echo -e "\n\033[0;36m================================= TERRAFORM VERSION SWITCHER ========================================================"
    echo -e "\nPlease select the number of one of the following functions to run:\n"

    for i in "${FUNCTIONS_LIST[@]}"
    do
        printf "   $j. $i \n"
        j=$(( $j + 1 ))
    done
    echo -e "\n=====================================================================================================================\n\033[0m"
    j=$(( $j - 1 ))         # set the number of functions to available
    printf "\033[1;36mPlease enter your choice (1 - $j): \033[0m"
    read CHOICE

    CHECKER="False"
    while [ "$CHECKER" == "False" ];
    do
          if [[ "$CHOICE" =~ ^[0-9]+$ ]] && [ "$CHOICE" -ge 1 -a "$CHOICE" -le "$j" ];
          then
              CHECKER="True"
              break
          else
              printf "\033[1;36mInvalid option! Please re-enter your choice (1 - $j): \033[0m"
              read CHOICE
          fi
    done

    EXEC_FUNC=${FUNCTIONS_LIST[$(( $CHOICE - 1 ))]}
    $EXEC_FUNC
}


### MAIN
Main_Function

