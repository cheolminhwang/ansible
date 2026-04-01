#!/usr/bin/env python3

import subprocess
import sys
import json
##import jenkins
JENKINS_URL="https://build-oci.dhsie.hawaii.gov"
JENKINS_USER="chwang"
JENKINS_PASSWORD_OR_TOKEN="h%4\"[r\\"+"LXK|?GO|t"

JENKINS_URL="https://build-nonp.dhsie.hawaii.gov"
JENKINS_USER="CHWANG1"
JENKINS_PASSWORD_OR_TOKEN="S$9L2nCn1g"
JENKINS_KEYNAME="NewToken"

##wget https://build-oci.dhsie.hawaii.gov/jnlpJars/jenkins-cli.jar
JENKINS_CLI="./jenkins-cli.jar"
##wget https://github.com/jenkinsci/plugin-installation-manager-tool/releases/download/2.13.2/jenkins-plugin-manager-2.13.2.jar


def main():
    # Example usage
    if len(sys.argv) > 1:
        # Use command from command line argument
        command = ' '.join(sys.argv[1:])
    else:
        # Default example command
        command = "java -jar jenkins-plugin-manager-*.jar   --list -d /u01/app/jenkins/plugins/"

    print("=" * 50)
    #------- check the existing access tokens
    command = "./shGetExistingTokens.sh"
    tokens=call_bash(command, "" )
    print(f"{tokens}")

    print("=" * 50)


def call_bash(command, arg):
    try:
        result = subprocess.run(
            [command, JENKINS_URL, JENKINS_USER, JENKINS_PASSWORD_OR_TOKEN, arg], 
            shell=True, 
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            universal_newlines=True,  # equivalent to text=True in 3.7+
            check=True
        )
        #print(f"  {result}")
        return result.stdout
    except Exception as e:
        print(f"Unexpected error: {e}")
        return False

# Alternative function using more explicit splitting for space/tab
def get_command_output_to_set_explicit(command):
    """
    Alternative version that explicitly handles space and tab separation.
    """
    try:
        result = subprocess.run(
            command, 
            shell=True, 
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            universal_newlines=True,  # equivalent to text=True in 3.7+
            check=True
        )
        
        output_set = set()
        
        for line in result.stderr.strip().split('\n'):
            if line.strip():
                # Find first space or tab
                space_pos = line.find(' ')
                tab_pos = line.find('\t')
                
                # Get the position of the first delimiter (space or tab)
                if space_pos == -1:
                    delimiter_pos = tab_pos
                elif tab_pos == -1:
                    delimiter_pos = space_pos
                else:
                    delimiter_pos = min(space_pos, tab_pos)
                
                # Extract first string
                if delimiter_pos == -1:
                    # No space or tab found, entire line is the first string
                    first_string = line.strip()
                else:
                    first_string = line[:delimiter_pos].strip()
                
                if first_string:
                    output_set.add(first_string)
        
        return output_set
    
    except subprocess.CalledProcessError as e:
        print(f"Error executing command '{command}': {e}")
        print(f"Error output: {e.stderr}")
        return set()
    except Exception as e:
        print(f"Unexpected error: {e}")
        return set()

# function using more explicit splitting for space/tab
def asdf(command):
    """
    Alternative version that explicitly handles space and tab separation.
    """
    try:
        result = subprocess.run(
            command,
            shell=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            universal_newlines=True,  # equivalent to text=True in 3.7+
            check=True
        )

        output_set = set()

        for line in result.stderr.strip().split('\n'):
            if line.strip():
                # Find first space or tab
                space_pos = line.find(' ')
                tab_pos = line.find('\t')

                # Get the position of the first delimiter (space or tab)
                if space_pos == -1:
                    delimiter_pos = tab_pos
                elif tab_pos == -1:
                    delimiter_pos = space_pos
                else:
                    delimiter_pos = min(space_pos, tab_pos)

                # Extract first string
                if delimiter_pos == -1:
                    # No space or tab found, entire line is the first string
                    first_string = line.strip()
                else:
                    first_string = line[:delimiter_pos].strip()

                if first_string:
                    output_set.add(first_string)

        return output_set

    except subprocess.CalledProcessError as e:
        print(f"Error executing command '{command}': {e}")
        print(f"Error output: {e.stderr}")
        return set()
    except Exception as e:
        print(f"Unexpected error: {e}")
        return set()

if __name__ == "__main__":
    main()
    
    # Example of using the explicit version
    #print("\n" + "="*50)
    #print("Using explicit space/tab handling:")
    #example_set = get_command_output_to_set_explicit("ps aux")
    #print(f"Found {len(example_set)} unique process owners/commands")
    #for item in sorted(list(example_set)[:10]):  # Show first 10
        #print(f"  {item}")
