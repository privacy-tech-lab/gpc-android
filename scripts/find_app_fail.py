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
        elif "Process crashed: Bad access due to protection failure" in line:
            extracted_info.append ("-----------------------------------------------------------------")
            # Search backwards for the word "spawning"
            j = i - 1
            while j >= 0 and "Spawning" not in lines[j]:
                j -= 1
            if j >= 0:
                extracted_info.append(lines[j].strip())
            extracted_info.append ("-----------------------------------------------------------------")

    return extracted_info

def remove_duplicate_lines_string(input_string):
    unique_lines = set()

    for line in input_string:
        stripped_line = line.strip()
        if stripped_line:
            unique_lines.add(stripped_line)

    output_string = '\n'.join(unique_lines)
    return output_string

def remove_consecutive_duplicate_blocks_string(input_string):
    unique_blocks = []

    current_block = []
    for line in input_string:
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

    output_lines = [line for block in unique_blocks for line in block]
    output_string = '\n'.join(output_lines)
    return output_string

def package_name_only_string(input_string):
    matches = re.findall(r'`([^`]+)`', input_string)
    single_quote_matches = re.findall(r"'([^']+)'", input_string)
    
    output_lines = matches + single_quote_matches
    output_string = '\n'.join(output_lines)
    return output_string

# Replace 'your_file.txt' with the actual path to your text file
file_path = 'capture_log.txt'
info = extract_info(file_path)

info_2 = remove_consecutive_duplicate_blocks_string(info)
info_3 = package_name_only_string(info_2)

print (info_3)