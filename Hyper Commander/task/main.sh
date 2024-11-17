#! /usr/bin/env bash

# Function to display the menu
display_menu() {
    echo "------------------------------"
    echo "| Hyper Commander            |"
    echo "| 0: Exit                    |"
    echo "| 1: OS info                 |"
    echo "| 2: User info               |"
    echo "| 3: File and Dir operations |"
    echo "| 4: Find Executables        |"
    echo "------------------------------"
}

# Function to list files and directories
list_files_and_directories() {
    echo "The list of files and directories:"
    arr=(*)
    for item in "${arr[@]}"; do
        if [[ -f "$item" ]]; then
            echo "F $item"
        elif [[ -d "$item" ]]; then
            echo "D $item"
        fi
    done
}

# Function to display file options menu
display_file_options_menu() {
    echo "---------------------------------------------------------------------"
    echo "| 0 Back | 1 Delete | 2 Rename | 3 Make writable | 4 Make read-only |"
    echo "---------------------------------------------------------------------"
}

# Main program loop
while true; do
    # Print welcome message
    echo "Hello $USER!"

    # Display the menu
    display_menu

    # Wait for user input
    read -p "> " user_input

    # Handle user input
    case "$user_input" in
        0)
            echo "Farewell!"
            break
            ;;
        1)
            uname -sn
            ;;
        2)
            whoami
            ;;
        3)
            # File navigation starts here
            while true; do
                # List files and directories
                list_files_and_directories

                # Display file navigation menu
                echo "---------------------------------------------------"
                echo "| 0 Main menu | 'up' To parent | 'name' To select |"
                echo "---------------------------------------------------"
                read -p "> " file_input

                if [[ "$file_input" == "0" ]]; then
                    # Return to main menu
                    break
                elif [[ "$file_input" == "up" ]]; then
                    cd ..
                elif [[ -d "$file_input" ]]; then
                    cd "$file_input"
                elif [[ -f "$file_input" ]]; then
                    # File options menu loop
                    while true; do
                        display_file_options_menu
                        read -p "> " file_option

                        case "$file_option" in
                            0)
                                # Go back to file navigation
                                break
                                ;;
                            1)
                                rm "$file_input"
                                echo "$file_input has been deleted."
                                break
                                ;;
                            2)
                                echo "Enter the new file name:"
                                read new_file_name
                                mv "$file_input" "$new_file_name"
                                echo "$file_input has been renamed as $new_file_name"
                                break
                                ;;
                            3)
                                chmod 666 "$file_input"
                                echo "Permissions have been updated."
                                ls -l "$file_input"
                                break
                                ;;
                            4)
                                chmod 664 "$file_input"
                                echo "Permissions have been updated."
                                ls -l "$file_input"
                                break
                                ;;
                            *)
                                echo "Invalid input!"
                                ;;
                        esac
                    done
                else
                    echo "Invalid input!"
                fi
            done
            ;;
        4)
            echo "Enter an executable name:"
            read exec_name
            exec_path=$(which "$exec_name")
            if [[ -n "$exec_path" ]]; then
                echo "Located in: $exec_path"
                echo "Enter arguments:"
                read exec_args
                $exec_path $exec_args
            else
                echo "The executable with that name does not exist!"
            fi
            ;;
        *)
            echo "Invalid option!"
            ;;
    esac
done