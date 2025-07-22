import os

# CHANGE this to the absolute or relative path of your "modules" directory
ROOT_DIR = r"C:\Users\shlok.j.jambusariya\Desktop\terraform\terraform_project\modules"  # Example: 'D:\\terraform\\modules'

TARGET_FILES = {"main.tf", "output.tf", "variables.tf"}

for module_name in os.listdir(ROOT_DIR):
    module_path = os.path.join(ROOT_DIR, module_name)
    if os.path.isdir(module_path):
        print(f"\n======= MODULE: {module_name} =======\n")
        for fname in TARGET_FILES:
            fpath = os.path.join(module_path, fname)
            if os.path.isfile(fpath):
                print(f"-- File: {module_name}/{fname} --\n")
                with open(fpath, "r", encoding="utf-8") as f:
                    print(f.read())
                print("\n" + "-"*50 + "\n")
