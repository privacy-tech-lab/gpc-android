import os
import subprocess

def process_mitm_files_recursively(base_directory):
    """
    Recursively process all .mitm files in the specified directory and convert them to .har files.

    Args:
        base_directory (str): The path to the base directory containing .mitm files.
    """
    # Walk through all directories and files in the base directory
    for root, _, files in os.walk(base_directory):
        for file in files:
            if file.endswith(".mitm"):
                # Define the input and output file paths
                mitm_path = os.path.join(root, file)
                har_file = file.replace(".mitm", ".har")
                har_path = os.path.join(root, har_file)

                # Construct the mitmdump command
                command = [
                    "mitmdump",
                    "-nr", mitm_path,
                    "--set", f"hardump={har_path}"
                ]

                print(f"Processing: {mitm_path} -> {har_path}")

                try:
                    # Run the mitmdump command
                    subprocess.run(command, check=True)
                    print(f"Successfully created: {har_path}")
                except subprocess.CalledProcessError as e:
                    print(f"Error processing {mitm_path}: {e}")

if __name__ == "__main__":
    # Specify the base directory containing the .mitm files
    base_directory = "/Users/gpc-web/Desktop"

    if not os.path.isdir(base_directory):
        print(f"Invalid directory: {base_directory}")
    else:
        process_mitm_files_recursively(base_directory)
