#!/usr/bin/env bash
# installer.sh - Common library for installation scripts

# Function to check if software is already installed
check_installed() {
    local cmd="$1"
    local version_required="$2"
    local version_check_command="$3"

    echo "Checking if $cmd is already installed..."

    # Check if command exists
    if command -v "$cmd" &> /dev/null; then
        echo "$cmd is already installed."

        # Check version if specified
        if [ -n "$version_required" ] && [ -n "$version_check_command" ]; then
            local current_version
            current_version=$(eval "$version_check_command" 2>/dev/null || echo "unknown")
            echo "Current version: $current_version"

            # If version checking function is provided, use it
            if [ "$(type -t version_compare)" = "function" ]; then
                if version_compare "$current_version" "$version_required"; then
                    echo "Installed version ($current_version) meets or exceeds required version ($version_required)."
                    return 0
                else
                    echo "Installed version ($current_version) is older than required version ($version_required)."
                    return 2  # Upgrade needed
                fi
            # Simple string comparison fallback
            elif [ "$current_version" = "$version_required" ] || [ "$current_version" \> "$version_required" ]; then
                echo "Installed version ($current_version) meets or exceeds required version ($version_required)."
                return 0
            else
                echo "Installed version ($current_version) is older than required version ($version_required)."
                return 2  # Upgrade needed
            fi
        fi

        return 0  # Already installed, no version check or version is OK
    fi

    # If a custom check function is defined, use it
    if [ "$(type -t custom_check)" = "function" ]; then
        if custom_check; then
            return 0
        fi
    fi

    echo "$cmd is not installed."
    return 1  # Not installed
}

# Generic installation process
install() {
    local software_name="$1"
    local version_required="$2"
    local version_check_command="${3:-}"

    echo "=== $software_name Installation Script ==="

    # Check if already installed
    check_installed "$software_name" "$version_required" "$version_check_command"
    local install_status=$?

    case $install_status in
        0)  # Already installed and up to date
            echo "$software_name is already installed and up to date. No action needed."
            ;;
        1)  # Not installed
            echo "Proceeding with installation..."
            if [ "$(type -t setup)" = "function" ]; then
                setup
            else
                echo "No installation function defined. Cannot proceed."
                return 1
            fi
            ;;
        2)  # Needs upgrade
            echo "Proceeding with upgrade..."
            if [ "$(type -t update)" = "function" ]; then
                update
            else
                echo "No upgrade function defined. Using install function instead."
                setup
            fi
            ;;
        *)  # Unknown status
            echo "Unknown status code: $install_status. Exiting."
            return 1
            ;;
    esac

    # Final verification
    check_installed "$software_name" "$version_required" "$version_check_command"
    if [ $? -eq 0 ]; then
        echo "✓ $software_name is now properly installed."
        return 0
    else
        echo "✗ $software_name installation verification failed."
        return 1
    fi
}

# Optional: More sophisticated version comparison function
# Usage: version_compare "current_version" "required_version"
# Returns 0 if current >= required, 1 otherwise
version_compare() {
    local current="$1"
    local required="$2"

    # Convert versions to arrays
    IFS='.' read -ra current_array <<< "$current"
    IFS='.' read -ra required_array <<< "$required"

    # Compare each component
    for ((i=0; i<${#required_array[@]}; i++)); do
        if [ "${current_array[i]:-0}" -gt "${required_array[i]:-0}" ]; then
            return 0  # Current version is greater
        elif [ "${current_array[i]:-0}" -lt "${required_array[i]:-0}" ]; then
            return 1  # Current version is less
        fi
    done

    return 0  # Versions are equal or current has more components
}
