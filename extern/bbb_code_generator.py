import os

def replace_special_characters_in_file(input_file, output_file):
    """
    Reads a file, replaces new lines with '\n', tabs with '\t', and '[' with '[lb]',
    and writes the processed content to a new file.

    Parameters:
        input_file (str): Path to the input file.
        output_file (str): Path to the output file.
    """
    try:
        # Read the content of the input file
        with open(input_file, 'r') as infile:
            content = infile.read()

        # Process the content
        processed_content = content.replace('\n', '\\n').replace('\t', '\\t').replace('[', '[lb]')

        # Write the processed content to the output file
        with open(output_file, 'w') as outfile:
            outfile.write(processed_content)

        print(f"Processed content written to {output_file}")
    except FileNotFoundError:
        print(f"Error: The file {input_file} does not exist.")
    except Exception as e:
        print(f"An error occurred: {e}")

# Example usage
if __name__ == "__main__":
    # Input directory path
    input_dir = input("Enter the path to the directory containing files: ").strip()

    if not os.path.isdir(input_dir):
        print("Error: The provided path is not a valid directory.")
    else:
        # Process each file in the directory
        for filename in os.listdir(input_dir):
            input_file_path = os.path.join(input_dir, filename)

            if os.path.isfile(input_file_path):
                # Generate an output file path
                output_file_path = os.path.splitext(input_file_path)[0] + "_processed.txt"

                # Process the file
                replace_special_characters_in_file(input_file_path, output_file_path)
