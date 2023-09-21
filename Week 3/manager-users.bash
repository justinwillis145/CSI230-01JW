 GNU nano 6.2                                                                                                         manager-users.bash                                                                                                                   
            ;;
        a)
            u_add=${OPTION}
            ;;
        u)
            t_user=${OPTARG}
            ;;
        c)
            check_user=${OPTARG}
            ;;
        h)
            echo "Usage: $(basename $) [-a] | [-d] [-c username] -u username"
            exit 1
            ;;
        *)
            echo "Invalid Value."
            exit 1
            ;;
    esac
done

# Check to see if -a and -d are empty or if they are both specified throw an error

if [[ (${u_del} == "" && ${u_add} == "" && ${check_user} == "") || (${u_del} != "" && ${u_add} != "" && ${check_user} != "") ]]
then
        echo "Please specify -a or -d and the -u and username."

fi

#Check to ensure -u is specified
if [[ (${u_del} != "" || ${u_add} != "") && ${t_user} == "" ]]
then
        echo "Please specify a user (-u)!"
        echo "Usage: $(basename $0) [-a][-d] [-u username]"
        exit 1

fi

# Delete a user
if [[ ${u_del} ]]
then
        echo "Deleting user..."
        sed -i "/# ${t_user} begin/,/# ${t_user} end/d" wg0.conf
fi


#Add a user
if [[ ${u_add} ]]
then
        echo "Create the User..."
        bash Peer.bash ${t_user}
fi

# Check if the user exists in wg0.conf
if [[ ${check_user} ]]; then
    if grep -q "# ${check_user} begin" wg0.conf; then
        echo "User ${check_user} exists in wg0.conf"
    else
        echo "User ${check_user} does not exist in wg0.conf"
    fi
fi
