import re
def extract_info(filename):
    with open(filename, 'r') as file:
        lines = file.readlines()

    extracted_info = []
    prev_spawning_line = None

    for i, line in enumerate(lines):
        if "Failed to spawn: unable to find application with identifier" in line:
            extracted_info.append ("-----------------------------------------------------------------")
            extracted_info.append(lines[i].strip())
            extracted_info.append ("-----------------------------------------------------------------")
        elif "INSTALL_FAILED" in line:
            extracted_info.append ("-----------------------------------------------------------------")
            extracted_info.append(line.strip())
            extracted_info.append ("-----------------------------------------------------------------")
        elif "Failed to spawn: unexpectedly timed out while waiting for app to launch" in line:
            extracted_info.append ("-----------------------------------------------------------------")
            # Search backwards for the word "spawning"
            j = i - 1
            while j >= 0 and "Spawning" not in lines[j]:
                j -= 1
            if j >= 0:
                extracted_info.append(lines[j].strip())
            extracted_info.append ("-----------------------------------------------------------------")

    return extracted_info

def remove_duplicate_lines(input_file_path, output_file_path):
    unique_lines = set()

    with open(input_file_path, 'r') as input_file:
        for line in input_file:
            stripped_line = line.strip()
            if stripped_line not in unique_lines:
                unique_lines.add(stripped_line)

    with open(output_file_path, 'w') as output_file:
        for line in unique_lines:
            output_file.write(line + '\n')

def remove_consecutive_duplicate_blocks(input_file_path, output_file_path):
    unique_blocks = []

    with open(input_file_path, 'r') as input_file:
        current_block = []
        for line in input_file:
            stripped_line = line.strip()
            if len(current_block) < 3:
                current_block.append(stripped_line)

            if len(current_block) == 3:
                if current_block not in unique_blocks:
                    unique_blocks.append(current_block)
                current_block = []

        if current_block:  # Handling the last block if it's not completed
            if current_block not in unique_blocks:
                unique_blocks.append(current_block)

    with open(output_file_path, 'w') as output_file:
        for block in unique_blocks:
            for line in block:
                output_file.write(line + '\n')

def package_name_only (input_filename, output_filename):
    with open(input_filename, 'r') as input_file, open(output_filename, 'w') as output_file:
        content = input_file.read()
        matches = re.findall(r'`([^`]+)`', content)
        single_quote_matches = re.findall(r"'([^']+)'", content)

        
        for match in matches:
            output_file.write(match + '\n')
        for match in single_quote_matches:
            output_file.write(match + '\n')

# Replace 'your_file.txt' with the actual path to your text file
file_path = 'capture_log.txt'
info = extract_info(file_path)

for item in info:
    print(item)

remove_consecutive_duplicate_blocks("find_error_output.txt", "find_error_output_2.txt")
package_name_only("find_error_output_2.txt", "find_error_output_3.txt")