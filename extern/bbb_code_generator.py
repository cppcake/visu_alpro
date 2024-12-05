import os

def replace_special_characters_in_file(input_file, output_file):
    """
    Reads a file, replaces new lines with '\n' and tabs with 't', 
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
    # Input file path
    input_file_path = input("Enter the path to the input file: ").strip()
    
    # Generate an output file path
    output_file_path = os.path.splitext(input_file_path)[0] + "_processed.txt"
    
    replace_special_characters_in_file(input_file_path, output_file_path)
