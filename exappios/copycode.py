import os
import pyperclip

def find_swift_files(directory):
    swift_files = []
    for root, _, files in os.walk(directory):
        for file in files:
            if file.endswith('.swift'):
                swift_files.append(os.path.join(root, file))
    return swift_files

def read_files(files):
    content = ""
    for file in files:
        with open(file, 'r', encoding='utf-8') as f:
            content += f"\n// {os.path.basename(file)}\n"
            content += f"{f.read()}\n"
    return content

def copy_to_clipboard(content):
    pyperclip.copy(content)

def main():
    directory = os.getcwd()
    swift_files = find_swift_files(directory)
    content = read_files(swift_files)
    copy_to_clipboard(content)
    print("All .swift file contents have been copied to the clipboard.")

if __name__ == "__main__":
    main()
